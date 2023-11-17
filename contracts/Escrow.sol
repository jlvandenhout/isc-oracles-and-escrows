// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@iota/iscmagic/ISC.sol";
import "./Oracle.sol";

contract Escrow {
  address public immutable BUYER;
  address public immutable SELLER;
  Oracle immutable PARCEL_STATUS;
  bytes32 immutable PARCEL;

  constructor(address seller, address parcel_status) payable {
    BUYER = msg.sender;
    SELLER = seller;
    PARCEL_STATUS = Oracle(parcel_status);
    PARCEL = PARCEL_STATUS.request(ISC.sandbox.getEntropy());
  }

  function deposit() public payable {
    require(msg.sender == BUYER, "Not the buyer.");
  }

  function withdraw() public view returns (bool) {
    return PARCEL_STATUS.get(PARCEL) != 0;
  }
}
