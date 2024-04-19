# Docker-Compose Publish

A GitHub Action that builds and publishes containers from docker-compose.yml to the current GitHub repository as packages.

## Example Usage
```
    - name: publish
      uses: marcfowler/publish_docker-compose@master
      with:
        version: '0.2.6-rc.1' # optional version string
        docker_compose: 'docker-compose.build.yml' # provide additional build-specific compose file
        repo_token: "${{ secrets.DEPLOY_TOKEN }}" # token with publishing permissions
        container_naming: "short" # defaults to 'full' which includes the repository name
```

## Input

Below is a breakdown of the expected action inputs.

### `version`

Explicit version number to use. Defaults to calculating this for you.

### `docker_compose`

Provide an additional build-specific `docker-compose.yml` file to use. Optional.

### `repo_token`

Provide a token with publishing permissions.

`${{ secrets.GITHUB_TOKEN }}` will work if everything is under the same organisation, or alternatively provide `${{ secrets.DEPLOY_TOKEN }}` (see below)

## Providing a deployment token

You may need/want to provide a Personal Access Token to grant access across different GitHub Organisations etc.

To do this, create a specific Personal Access Token and provide it as a secret to this repository:

1. Click your profile picture in the top-right and click Settings
2. Click 'Developer settings' in the bottom left of the sidebar
3. Click 'Personal Access Tokens', and then 'Tokens (classic)'
4. Generate a new token with the `write:packages` permission
5. Copy the token, head back to the repository, and click 'Settings'
6. Click 'Secrets and variables' in the sidebar, and choose 'Actions'
7. Add the repository secret with the name `DEPLOY_TOKEN` and the token