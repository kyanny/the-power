# The Power

![the-power](https://github.com/gm3dmo/the-power/actions/workflows/the-power.yml/badge.svg)


## Table of Contents

1. [What is the Power?](#what-is-the-power)
2. [Setup Instructions](docs/setup.md)
3. [Contributing to The Power](CONTRIBUTING.md)
4. [Known Issues/Problems/Solutions](docs/known-issues.md)
5. [Testcases](docs/testcases.md)

## What is The Power?
The Power is a very simple test framework to help you interact with and understand the GitHub API's by building pre-defined test scenarios extra goodies to a testing instance of [GitHub Enterprise](https://docs.github.com/en/enterprise-server@3.5/admin/overview/about-github-enterprise-server) or on GitHub.com a pre-existing [Organization](https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/about-organizations) and [Enterprise Account](https://docs.github.com/en/get-started/onboarding/getting-started-with-github-enterprise-cloud).

The Power adds the following to a blank appliance or organization in <=30 seconds:

* An [Organization](https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/about-organizations).
* Users
* A [team](https://docs.github.com/en/github/setting-up-and-managing-organizations-and-teams/about-teams) of users.
* A private [repository](https://docs.github.com/en/repositories) named *testrepo* with a [branch](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-and-deleting-branches-within-your-repository) called *new_branch*,
* [Branch protection](https://docs.github.com/en/github/administering-a-repository/about-protected-branches) rules on branch `main`.
* [*CODEOWNERS*](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/about-code-owners) file configured for the *README.md* and `.gitattributes` files.
* An [Issue](https://github.com/features/issues).
* A [pull request](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests) with a the code owner requested for review. 
* A manifest file for a package manager file with a vulnerability to trigger [Dependabot](https://docs.github.com/en/code-security/dependabot)
* A [webhook](https://docs.github.com/en/developers/webhooks-and-events/about-webhooks) on *testrepo* that outputs to it's own [smee.io](https://smee.io) url.
* A [Release](https://docs.github.com/en/github/administering-a-repository/managing-releases-in-a-repository).
* [GitHub Pages](https://docs.github.com/en/pages) configured for *testrepo*.
* A [Gist](https://docs.github.com/en/github/writing-on-github/creating-gists).
* Mermaid diagrams using [create-commit-mermaid.sh](create-commit-mermaid.sh) to demonstrate the GitHub supported diagram types on [the mermaid project](https://mermaid-js.github.io/mermaid/#/n00b-gettingStarted).

There are many other features and test-cases you can use or adapt to build scenarios of your own.

### The Power is a tool for learning
- Designed to be as simple as possible to understand. To keep things simple we exclusively uses only `curl` and `jq` to complete most tasks. Only a few of the more complex scenarios have other dependencies.

### The Power is vast and deep
There are hundreds of pre-baked scripts to:

* Create commits, secrets, hooks, issue comments, environments.
* Bulk up your appliance by creating hundreds or thousands of users/orgs/repos/teams/pull requests.
* Set up a Tiny [GitHub App](https://docs.github.com/en/developers/apps/getting-started-with-apps/about-apps) in less than 1 minute.
* Demonstrate [GitHub Actions](https://docs.github.com/en/actions).
* Demonstrate [Code scanning](https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/about-code-scanning).

### The Power is highly configurable
The configuration file `.gh-api.examples.conf` is the green fuse that drives The Power. The configuration file format is simply key value pairs:

```
# Branches and Branch protection
branch_name="new_branch"
protected_branch_name="main"
required_approving_reviewers=1
enforce_admins="false"
base_branch="main"
```

### The Power's configuration can be shared with other tools
The use of `kv` pairs in `.gh-api-examples.conf` provides maximum flexibility and simplicity. It allows the configuration file to provide the basic descriptors for other more advanced tools like Apache JMeter or [hurl](https://hurl.dev/)

#### Hurl using the `.gh-api-examples.conf file`
[hurl-repo-characteristics.sh](https://github.com/gm3dmo/the-power/blob/main/hurl-repo-characteristics.sh) provides a demonstration of hurl configuring itself with `.gh-api-examples.conf`: 

```
hurl --test --variables-file .gh-api-examples.conf --json hurl-tests/repo-characteristics.hurl | jq -r
```
The `hurl-tests/repo-characteristics` file looks like:

```
GET {{ GITHUB_API_BASE_URL }}/repos/{{ org }}/{{ repo }}
Accept: application/vnd.github.v3+json
Authorization: token {{ GITHUB_TOKEN }}

HTTP/2 200

[Asserts]
status >= 200
status < 300
header "Content-Type" == "application/json; charset=utf-8"
header "x-github-request-id" isString
jsonpath "$.name" == "{{ repo }}"
jsonpath "$.full_name" == "{{ org}}/{{ repo }}"
```

### Why The Power
There are lots of great tools like [Postman](https://www.postman.com/), [JMeter](https://jmeter.apache.org/) for interacting with API's and building testsuites and many of the latest API's come with their own interactive documentation built-in like the [swagger petstore](https://petstore.swagger.io/). The Power is a solution for times and places where those tools just aren't available. 
