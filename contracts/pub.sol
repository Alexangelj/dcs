//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface LabLike {
    function hope(address) external;
    function nope(address) external;
    function bags(bytes32) external view returns (
        uint256 rate, // staked multiplier
        uint256 ceil, // rep debt ceil
        uint256 Ice,  // total collateral
        uint256 Amp   // total debt
    );
    function cups(bytes32, address) external view returns (
        uint256 ice, // loot balance
        uint256 amp  // debt balance
    );
    function live() external view returns(uint256);
}

interface Kicker {
    function kick(address ape, address fox, uint256 lot, bytes32 toy, uint256 bid) external returns (uint256 id);
}

interface ZipLike {
    
}

contract Pub {
    // --- Auth ---
    error Auth();
    mapping(address => uint) public wards;
    function rely(address usr) external auth { wards[usr] = 1; }
    function deny(address usr) external auth { wards[usr] = 0; }
    modifier auth() {
        if(wards[msg.sender] != 1) revert Auth();
        _;
    }

    // --- Data ---
    struct Bag {
        address flib; // liquidator
    }

    mapping(bytes32 => Bag) public bags;

    LabLike public lab; // Game engine
    ZipLike public zip; // Debt engine
    uint256 public live;

    // --- Events ---
    event Wake(bytes32 indexed bag, address indexed cup, uint256 lot);

    // --- Errors
    error Err(string msg);

    // --- Init ---
    constructor(address lab_, address pub_) {
        lab = LabLike(lab_);
        zip = ZipLike(pub_);
        wards[msg.sender] = 1;
        live = 1;
    }

    // --- Admin ---
    function file(bytes32 bag, bytes32 what, address flib) external auth {
        if(what == "flib") {
            lab.nope(bags[bag].flib);
            bags[bag].flib = flib;
            lab.hope(flib);
        } 
        else revert Err("Pub/unrecognized-param"); 
    }

    // Game round
    function wake(bytes32 bag, address cup) external returns(uint256 id) {
        if(live != 1) revert Err("Pub/not-live");

        (uint256 rate, , ,) = lab.bags(bag);
        (uint256 ice, uint256 amp) = lab.cups(bag, cup);

        Bag memory ebag = bags[bag];


        id = Kicker(ebag.flib).kick({
            ape: msg.sender,
            fox: cup,
            lot: rate,
            toy: bag,
            bid: 0
        });

        emit Wake(bag, cup, rate);
    }

    function cage() external auth {
        live = 0;
    }
}
