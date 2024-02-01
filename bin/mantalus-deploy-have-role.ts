#!/usr/bin/env node
import 'source-map-support/register';
import * as fs from 'fs';
import * as path from 'path';
import * as cdk from 'aws-cdk-lib';
import { BuildConfig } from '../interfaces/build-config';
import { HavaReadOnlyRoleStack } from "../lib/hava-read-only-role-stack";
// eslint-disable-next-line @typescript-eslint/no-var-requires
const yaml = require('js-yaml');

async function getConfig() {
  const env = app.node.tryGetContext('config');
  if (!env) throw new Error("Must pass a '-c config=<Env>' context parameter");

  const buildConfigCommon: BuildConfig = yaml.load(fs.readFileSync(path.resolve('./config/common.yaml'), 'utf8'));

  const buildConfigEnv: BuildConfig = yaml.load(fs.readFileSync(path.resolve('./config/' + env + '.yaml'), 'utf8'));

  // Deep merge can be tricky but because we know the data structure it's not a problem - https://stackoverflow.com/questions/61902833/deep-merging-objects-with-the-spread-operator
  const buildConfig = {
    ...buildConfigCommon,
    ...buildConfigEnv,
    Tags: { ...buildConfigCommon.Tags, ...buildConfigEnv.Tags },
  }; // 👉️ Combined buildConfig object

  console.log('buildConfig stringified output: ' + JSON.stringify(buildConfig, null, 2));

  return buildConfig;
}

// 👇 creating our CDK App
const app = new cdk.App({});

async function Main() {
  const buildConfig: BuildConfig = await getConfig();

  const commonTags = { ...buildConfig.Tags }; // 👉️  Common tags object

  new HavaReadOnlyRoleStack(app, 'HavaReadOnlyRoleStack', {
    env: {},
    havaAwsAccount: buildConfig.havaAwsAccount,
    havaExternalId: buildConfig.havaExternalId,
    tags: commonTags,
    description: "This stack creates an IAM policy and role that allows Hava to read your AWS resources."
  });
}

Main();