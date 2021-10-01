# MSSQL 2017 spawn docker image

This image is necessary to allow us to run SQL 2017 containers as non-root users.

SQL 2019 runs as non-root by default, but 2017 does not. Microsoft's suggested fix for this is to build a custom docker image yourself, so that's what this is doing.

## Deploying Changes

Building & pushing this image is now automated as part of our deployment. If you make changes to the Dockerfile, you will need to bump the version number by overriding the `$MSSQL_IMAGE_VERSION` variable in this pipeline, and kick off the [DB Engine images build & deploy pipeline](https://foundry-labs.visualstudio.com/spawn/_build?definitionId=64). You will need to make some code changes, to bump the version of this custom image (it isn't the most ideal, but it's better than before with using a variable in the Library group - we prefer being able to look at the code and know exactly what version of MSSQL we're using).

You should deploy the new tagged version to our ECR repo **first**, otherwise it'll never use the newly tagged version in production.

To update instances within the code base, do a **Find and Replace within the Spawn repo on what the current version is** (`2017-CU20-ubuntu-16.04`) - update this README too, to reflect what will be the current version once your changes are merged.

It should be these following files that change with the Find and Replace function, but this can easily get out of date with files moving/other places referencing the version in the future, which is why Find and Replace is better:
 - `Spawn.Models/DatabaseEngine.cs` - there is a method mapping versions to their docker tag equivelent
 - `operator/.../database_engines.go` - there is a method mapping versions to their docker tag equivelent
 - `spawn.cc/.../apiserver/configmap.yml` is the source of truth of what engine versions we support
 - `pull_docker_images.sh` pulls the MSSQL image from our repo to our machine, needed for dev environment
 - `spawn.cc/spawn/values.yaml` - value set here prepulls images in production

## Testing 

To build the image, run the following at `/spawn/docker-images` level:

```bash
make build_spawn_mssql_image
```

It will build an image tagged `latest`

To push the image, run the following at `/spawn/docker-images` level:

```bash
make push_spawn_mssql_image LATEST_VERSION=<your-version-tag>
```

You can omit passing it `LATEST_VERSION`, it'll instead just tag it `DEV` and push to our ECR repo.

You can now view the image in our [AWS ECS registry](https://eu-west-2.console.aws.amazon.com/ecr/repositories/private/446400974142/spawn/mssql-2017?region=eu-west-2).
