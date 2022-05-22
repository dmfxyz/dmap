// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";

contract ContractTest is DSTest {

    // Address of publicly deployed dmap
    address dmap_address = address(0x90949c9937A11BA943C7A72C3FA073a37E3FdD96);
    // selector is ignored by contract
    bytes4 SEL = bytes4(0x00000000);

    function testBasicSetAndGet() public {
        bytes32 name = bytes32("name");
        bytes32 meta = bytes32("meta");
        bytes32 data = bytes32("data1");

        // test set meta and data
        bytes memory call_data = abi.encodePacked(SEL,name,meta,data);
        (bool ok1, ) = dmap_address.call(call_data);
        require(ok1);

        // test get meta
        bytes32 meta_slot = keccak256(abi.encode(address(this), name));
        (bool ok2, bytes memory ret2) = dmap_address.call(abi.encodePacked(SEL, meta_slot));
        require(ok2);
        bytes32 returned_meta = abi.decode(ret2, (bytes32));
        assertEq(meta, returned_meta);

        // test get data
        bytes32 data_slot;
        assembly {
            data_slot := add(1, meta_slot)
        }
        (bool ok3, bytes memory ret3) = dmap_address.call(abi.encodePacked(SEL, data_slot));
        require(ok3);
        bytes32 returned_data = abi.decode(ret3, (bytes32));
        assertEq(data, returned_data);
    }
}
