pragma solidity ^0.5.0;

contract Verify {
    address importantAddress;

    constructor(address _importantAddress) public {
        importantAddress = _importantAddress;
    }

    function splitSignature(bytes memory sig)
        public
        pure
        returns (
            bytes32,
            bytes32,
            uint8
        )
    {
        require(sig.length == 65);
        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            // next 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // next 32 bytes after r
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes) - last byte in the signature, mload picks 32 bytes at a time, so we need to pick just the first 2
            v := byte(0, mload(add(sig, 96)))
        }

        return (r, s, v);
    }

    function recoverSigner(bytes32 message, bytes memory sig)
        public
        pure
        returns (address)
    {
        uint8 v;
        bytes32 r;
        bytes32 s;
        (v, r, s) = splitSignature(sig);
        return ecrecover(message, v, r, s);
    }

    function isValidData(
        uint256 _number,
        string memory _word,
        bytes memory sig
    ) public returns (bool) {
        bytes32 message = keccak256(abi.encodePacked(_number, _word));
        return (recoverSigner(message, sig) == importantAddress);
    }
}
