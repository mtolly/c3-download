First run `./api.rb api.yaml` to get the list of songs, saved to `api.yaml`.

Then `./download_all.rb api.yaml` will start downloading files to the folder `cons/`.

Optionally, `./move_old.rb api.yaml` will move files from `cons/` to `oldcons/`
if they are no longer present in the API results
(either the song was taken down, or a newer version replaced it).
