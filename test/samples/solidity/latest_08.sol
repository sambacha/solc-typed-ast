pragma solidity ^0.8.0;
pragma abicoder v2;

import "./latest_imports_08.sol" as LI;

contract UncheckedMathExample {
    function test() public pure returns (uint) {
        uint x = 0;

        unchecked {
            x--;
        }

        return x;
    }
}

contract EmitsIdentifierPath is LI.SomeContract {
    using LI.SomeLib for LI.SomeContract.SomeStruct;

    constructor() LI.SomeContract() {}

    function test() public {
        LI.SomeContract.SomeStruct memory s = LI.SomeContract.SomeStruct(10);
    }

    function some() override(LI.SomeContract) public returns(uint) {
        return 2;
    }
}

contract UsesNewAddressMembers {
    function test() public {
        bytes memory code = address(0).code;
        bytes32 codeHash = address(0).codehash;
    }
}
