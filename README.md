# Build Collective

Welcome to the DAAR project. The idea will be to implement an OpenCollective competitor
in a decentralized way, on Ethereum. This will have cool side effects, like not
be forced to pay for servers.

# Installation

```bash
# With HTTPS
git clone https://github.com/ghivert/build-collective.git
# Or with SSH
git clone git@github.com:ghivert/build-collective.git
```

You’ll need to install dependencies. You’ll need [`Ganache`](https://www.trufflesuite.com/ganache), [`Node.js`](https://nodejs.org/en/) and [`NPM`](https://www.npmjs.com/) or [`Yarn`](https://yarnpkg.com/). You’ll need to install [`Metamask`](https://metamask.io/) as well to communicate with your blockchain.

- `Ganache` is a local blockchain development, to iterate quickly and avoiding wasting Ether during development.
- `Node.js` is used to build the frontend and running `truffle`, which is a utility to deploy contracts.
- `NPM` or `Yarn` is a package manager, to install dependencies for your frontend development. Yarn is recommended.
- `Metamask` is a in-browser utility to interact with decentralized applications.

# Some setup

Once everything is installed, launch `Ganache`. Create a new workspace, give it a name, and accept. You should have a local blockchain running in local. Now you can copy the mnemonic phrase Ganache generated, open Metamask, and when it asks to import a mnemonic, paste the mnemonic. Create the password of your choice and that’s fine.
Now you can connect Metamask to the blockchain. To do this, add a network by clicking on `main network` and `personalized RPC`. Here, you should be able to add a network.

![Ganache Config](public/ganache-config.png)

Once you have done it, you’re connected to the Ganache blockchain!

# Run the frontend

Install the dependencies.

```bash
# Yarn users
yarn
# NPM users
npm install
```

Compile the contracts.

```bash
# Yarn users
yarn contracts:migrate
# NPM users
npm run contracts:migrate
```

Create a symlink for your OS if this is not done for you.

```bash
# Windows
mklink /D src\build "..\build"

# Unix and macOS
ln -s ../build ./src/build
```

Run the frontend

```bash
# Yarn users
yarn serve
# NPM users
npm run serve
```

You’re good to go!

# Subject

Implement an OpenCollective from scratch in Solidity.

# Smart Contract

- Open user account, with a name and a balance.
- Open an entreprise account, with a name, an owner and some members, possibly with a balance.
- Create projects on which we can give money for sponsoring. Each project has a balance, a name and a list of contributors. Each project belongs to a user or an entreprise. The money given to the project can be send to contributors, and contributors only.
- On a project, you should be able to create bounties. Bounties are bugs with a reward: if you spot a bug and you want to have it fix quickly, open a bounty and put some eth on it. When the fix is pushed, the author will get the eth. He’s a bounty hunter.
- Add the ability to put some link to commits from GitHub or GitLab in the projects, to keep a track of what has been done.

# Front

- Create a page to open a user account. Remember, each user is identified by its wallet address.
- Create a page to open an entreprise account.
- Create a page to create a project.
- Create a page to get a full recap of everything that happened on a project as a timeline.
- Project details page
    - Contribute to a project
    - Pay contributors (only owner)
    - Create bounty (only owner)
    - Accept a fix (only owner)
    - Propose a fix

# Screenshot
## Home
![image](https://user-images.githubusercontent.com/28400679/143787353-bab97531-e313-4a47-9e5c-9d30ce53b455.png)
## Account
![image](https://user-images.githubusercontent.com/28400679/143787383-bb61a65c-6fb2-4c55-b013-f40aac007477.png)
## Company
![image](https://user-images.githubusercontent.com/28400679/143787427-a77ac69f-3f9f-4bf1-a89c-1c3db146373f.png)
## Company details
![image](https://user-images.githubusercontent.com/28400679/143787462-4e8e5f39-9858-4b06-9538-f3bd796ec9c8.png)
## Project
![image](https://user-images.githubusercontent.com/28400679/143787486-87351c5e-d3ec-4bcb-9c3e-f9c085bfdc4b.png)
## Project Details
![image](https://user-images.githubusercontent.com/28400679/143787518-f21ecd5b-0620-449d-95b4-a182cbe03f9e.png)
## Bounty
![image](https://user-images.githubusercontent.com/28400679/143787549-2c1bc8b6-5ce4-4064-b45e-cba61f06614f.png)
## Bounty Details
![image](https://user-images.githubusercontent.com/28400679/143787612-bc7b3b7e-e5dd-4d23-b3ba-775d221f981c.png)
