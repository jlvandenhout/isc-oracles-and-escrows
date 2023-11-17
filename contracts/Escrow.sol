// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Oracle.sol";

contract Escrow {
  address public immutable BUYER;
  address public immutable SELLER;
  Oracle immutable PARCEL_STATUS;

  constructor(address seller, address parcel_status) payable {
    BUYER = msg.sender;
    SELLER = seller;
    PARCEL_STATUS = Oracle(parcel_status);
  }

  function deposit() public payable {
    require(msg.sender == BUYER, "Not the buyer.");
  }

  function withdraw() public {

  }
}
