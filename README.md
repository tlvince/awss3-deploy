# awss3-deploy

[![Build Status][travis-image]][travis-url]
[![npm version][npm-image]][npm-url]
[![License][license-image]][license-url]

[travis-url]: https://travis-ci.org/tlvince/awss3-deploy
[travis-image]: https://img.shields.io/travis/tlvince/awss3-deploy.svg
[npm-url]: https://www.npmjs.com/package/awss3-deploy
[npm-image]: https://img.shields.io/npm/v/awss3-deploy.svg
[license-url]: https://opensource.org/licenses/MIT
[license-image]: https://img.shields.io/npm/l/awss3-deploy.svg

> Deploy artefacts with aws-cli to S3

Deploys a `local` directory to a `dest` directory of an S3 bucket. Sets a `cache-control` header to a far-future expiry (one year) for everything *except* `index.html`, which is set to `no-cache, no-store`. Archives existing `dest` under a datetime directory scheme. Intended to be used as a [TravisCI deploy script][travis-dpl].

[travis-dpl]: https://docs.travis-ci.com/user/deployment/script

## Installation

```shell
# pip install awscli
npm install --save awss3-deploy
```

[awscli]: https://aws.amazon.com/cli/

## Usage

```shell
BUCKET="mybucket" LOCAL_DIR="dist" UPLOAD_DIR="dev" ./node_modules/.bin/awss3-deploy
```

### TravisCI

`.travis.yml`:

```yml
before_deploy:
  - export BUCKET=mybucket LOCAL_DIR=dist UPLOAD_DIR=dev
deploy:
  provider: script
  script: awss3-deploy
  skip_cleanup: true
```

### S3 Permissions

Your S3 bucket needs the `s3:ListBucket` permission on the bucket itself and
`s3:{Delete,Get,Put}Object` on the bucket's contents. An example bucket policy
might look like the following:

```json
{
  "Version": "2016-05-03",
  "Id": "awss3-deploy",
  "Statement": [
    {
      "Sid": "1",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::[account]:user/[user]"
      },
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": "arn:aws:s3:::[bucket]"
    },
    {
      "Sid": "2",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::[account]:user/[user]"
      },
      "Action": [
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::[bucket]/*"
    }
  ]
}
```

## ITYMFAQLT

> I think you might frequently ask questions like these

### Why not Travis' default S3 deployment provider?

* It does not support per-object cache-control headers (*yet*; see: [#170][])
* We needed additional life-cycle/archival rules (alternatively, AWS Lambda could be used)

[#170]: https://github.com/travis-ci/dpl/pull/170

## Author

© 2016 Tom Vincent <git@tlvince.com> (https://tlvince.com)

## License

Released under the [MIT license](http://tlvince.mit-license.org).
