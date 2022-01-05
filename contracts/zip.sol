//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface LabLike {}

interface FlubLike {
    function kick(address ape, address fox, uint256 lot, bytes32 toy, uint256 bid) external returns (uint256);
    function cage() external;
    function live() external view returns(uint256);
}

interface FlabLike {
    function kick(uint256 lot, uint256 bid) external returns (uint256);
    function cage() external;
    function live() external view returns(uint256);
}

contract Zip {
    // --- Auth ---
    error Auth();
    mapping(address => uint) public wards;
    function rely(address usr) external auth { wards[usr] = 1; }
    function deny(address usr) external auth { wards[usr] = 0; }
    modifier auth() {
        if(wards[msg.sender] != 1) revert Auth();
        _;
    }

    LabLike  public lab;
    FlabLike public flabber;
    FlubLike public flubber;

    uint256 public  bump; // Fixed bag lot size
    uint256  public live; // Active flag

    // --- Errors ---
    error Err(string msg);

    // --- Init ---
    constructor(address lab_, address flab_, address flub_) {
        wards[msg.sender] = 1;
        lab     = LabLike(lab_);
        flabber = FlabLike(flab_);
        flubber = FlubLike(flub_);
        live = 1;
    }

    // Surplus auction
    function flab() external returns (uint256 id) {
        id = flabber.kick(bump, 0);
    }

    // ??
    function flub() external returns (uint256 id) {
        //id = flubber.kick();
    }

    function cage() external auth {
        if(live != 1) revert Err("Zip/not-live");
        live = 0;
        flabber.cage();
        flubber.cage();
    }
}
