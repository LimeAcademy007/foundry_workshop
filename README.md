# foundry_workshop

All things contracts & tooling for Web3.

## Setting up

- Open your terminal and type in the following command:

```
curl -L https://foundry.paradigm.xyz | bash
```

- This will download foundryup. Then install Foundry by running:

```
foundryup
```

- for installing dependent submodules in the project run:

```
forge install
```

- example environment variables

```
PRIVATE_KEY="0x..."
ETHERSCAN_API_KEY="YOUR_API_KEY"
PROVIDER="https://eth-goerli.g.alchemy.com/v2/API_KEY"
```

- for running a local node run

```
anvil
```

## Test Examples:

     *  - [x] `assertEq`
     *  - [x] `testFail`
     *  - [x] `expectRevert`
     *  - [x] `testLogSomething`
     *  - [x] `assertTrue`
     *  - [x] `Error`
     *  - [x] vm.warp
     *  - [x] vm.roll
     *  - [x] vm.ExpectEmit
     *  - [x] vm.startPrank / vm.stopPrank
     *  - [x] vm.deal
     *  - [x] vm.hoax
     *  - [ ] vm.assume (fuzz testing). Good and bad examples ref: https://book.getfoundry.sh/cheatcodes/assume?highlight=assume#assume
     *  - [ ] bounds checking ref: https://book.getfoundry.sh/reference/forge-std/bound
     *  - [ ] signing strings
     *  - [ ] signing permits (ERC20)
     *  - [ ] invariants
     *  - [ ] console.log on already deployed contract on fork
     */
