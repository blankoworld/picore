require "json"
require "http"
require "file"
require "./github.cr"

header = <<-HEADER
#!/usr/bin/env bash
#
# Paramètres de configuration du projet Genèse.
#
# TODO: décrire ici les différentes variables à surcharger
HEADER

module Picore
  VERSION = "0.1.0"
end


# Initialisation des variables
api_url = "https://api.github.com/repos/OWNER/PROJECT/pulls"
cfg_url = %(URL_PROJECT="VALUE")
cfg_branch = %(BRANCHE_PROJECT="VALUE")
extension = "PR.blk"

# 1. Initialisation d'OWNER + PROJECT
owner = ENV.fetch("OWNER", "blankoworld")
project = ENV.fetch("PROJECT" ,"dofus-almanax")
directory = ENV.fetch("DEST", "")
# 2. test des répertoires
if ! directory.empty? && ! File.exists?(directory)
  raise "#{directory} does not exists!"
end
# 3. Construction de l'URL
url = api_url.sub("OWNER", owner).sub("PROJECT", project)
# 4. Requête de l'URL
response = HTTP::Client.get url
# 5. Si requête OK, on parse
if response.status_code == 200
  content = response.body.lines
  # 6. transformation en JSON
  pulls = Array(Github::Pull).from_json(content[0])
  # 7. conversion en fichier .sh
  pulls.each do |pull|
    # préparation des variables pour la configuration
    repository = cfg_url
    branch = cfg_branch
    # composition de la configuration
    config = header + "\n"
    config += repository.sub("VALUE", pull.head.repo.clone_url).sub("PROJECT", project) + "\n"
    config += branch.sub("VALUE", pull.head.ref).sub("PROJECT", project) + "\n"

    # écriture de la configuration dans un fichier. Uniquement si besoin.
    filename = [owner, project, pull.number.to_s, extension].join(".")
    # ajout d'un dossier de destination si demandé
    if ! directory.empty?
      filename = [directory, filename].join("/")
    end
    if ! File.exists?(filename) || File.empty?(filename)
      File.write(filename, config)
    end
  end
end
# vim: ts=2 sw=2 et nu
