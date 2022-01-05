//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/*
    Game master is responsible for setting the config.
    Take care in thinking about the configuration of a level.
    Loot is at risk of falling into the wrong hands...
*/


contract Fig {
    // --- Auth ---
    error Auth();
    mapping(address => uint) public wards;
    function rely(address usr) external auth {
        wards[usr] = 1;
        emit Rely(usr);
    }
    function deny(address usr) external auth {
        wards[usr] = 0;
        emit Deny(usr);
    }
    modifier auth() {
        if(wards[msg.sender] != 1) revert Auth();
        _;
    }

    // --- Data ---
    struct Ink {
        uint256 lap; // immutable - betting period
        uint256 wax; // immutable - round period 
        uint256 fee; // immutable - % distributed to sponsors
        uint256 rep; // mutable   - min rep to sponsor
        uint256 max; // mutable   - max amount to sponsor
    }

    mapping(bytes32 => Ink) public inks;

    // Errors
    error File(bytes32 ink);

    // Events
    event Rely(address indexed usr);
    event Deny(address indexed usr);

    constructor(uint ) {
        wards[msg.sender] = 1;
    }

    // --- Admin ---
    function file(bytes32 ink, uint256 data) external auth {
        if(ink == "rep") inks[ink].rep = data;
        else if(ink == "max") inks[ink].max = data;
        else revert File(ink);
    }
}
