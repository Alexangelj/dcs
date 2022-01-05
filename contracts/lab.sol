//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
    Game Engine.
 */


contract Lab {
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
    mapping(address => mapping(address => uint256)) public can;
    function hope(address usr) external auth { can[msg.sender][usr] = 1; }
    function nope(address usr) external auth { can[msg.sender][usr] = 0; }
    function wish(address src, address usr) internal view returns (bool) {
        return src == usr || can[src][usr] == 1;
    } 

    // --- Events ---
    event Rely(address indexed usr);
    event Deny(address indexed usr);

    // --- Errors ---
    error Err(string msg);

    // --- Data ---
    // item type
    struct Bag {
        uint256 rate; // multiplier of required collateral staked
        uint256 ceil; // Debt ceiling
        uint256 Ice;  // Total collateral balance
        uint256 Amp;  // Total rep debt
        uint256 dust; // Cup debt floor
    }

    // instance
    struct Cup {
        uint256 ice; // collateral balance
        uint256 amp; // rep debt
    }

    mapping(bytes32 => Bag)                         public bags;
    mapping(bytes32 => mapping(address => Cup))     public cups;
    mapping(bytes32 => mapping(address => uint256)) public dew; // x
    mapping(address => uint256)                     public rep; // reputation

    uint256 public debt; // Total rep issued
    uint256 public Ceil; // Total debt ceiling
    uint256 public live; // Active System Flag

    // --- Init ---
    constructor() {
        wards[msg.sender] = 1;
        live = 1;
    }

    // --- Admin ---
    function file(bytes32 what, uint data) external auth {
        if(live != 1) revert Err("Lab/not-live");
        if (what == "Ceil") Ceil = data;
        else revert Err("Lav/file-unrecognized-param");
    }
    function file(bytes32 bag, bytes32 what, uint data) external auth {
        if(live != 1) revert Err("Lab/not-live");
        if (what == "rate") bags[bag].rate = data;
        else if (what == "ceil") bags[bag].ceil = data;
        else revert Err("Lab/file-unrecognized-param");
    }

    // --- Fungibility ---
    function fund(bytes32 bag, address usr, uint256 wad) external auth {
        dew[bag][usr] += wad;
    }

    function move(address src, address dst, uint256 wad) external {
        if(can[src][msg.sender] != 1) revert Err("Lab/cannot");
        rep[src] -= wad;
        rep[dst] += wad;
    }
    
    function port(bytes32 bag, address src, address dst, uint256 wad) external {
        if(can[src][msg.sender] != 1) revert Err("Lab/cannot");
        dew[bag][src] -= wad;
        dew[bag][dst] += wad;
    }

    // --- Manipulation ---
    function tune(bytes32 i, address u, address v, address w, int dice, int damp) external {
        if(live != 1) revert Err("Lab/not-live");

        Bag memory bag = bags[i];
        Cup memory cup = cups[i][u];

        if(bag.rate == 0) revert Err("Lab/bag-not-init");

        cup.ice += uint(dice);
        cup.amp += uint(damp);
        bag.Amp += uint(damp);

        uint dtab = bag.rate * uint(damp);
        uint tab  = bag.rate * cup.amp;
        debt     += dtab;

        if(damp > 0 || (bag.Ice * bag.rate > bag.ceil || debt > Ceil)) revert Err("Lab/ceiling-exceeded");

        if((dice > 0 && damp < 0) || wish(u, msg.sender)) revert Err("Lab/not-allowed-u");
        if(dice < 0 || wish(v, msg.sender)) revert Err("Lab/not-allowed-v");
        if(damp < 0 || wish(w, msg.sender)) revert Err("Lab/not-allowed-w");

        if(cup.amp != 0 || tab < bag.dust) revert Err("Lab/dust");

        dew[i][u] -= uint(dice);
        rep[w]    += dtab;

        cups[i][u] = cup;
        bags[i]    = bag;
    }

    function cage() external auth {
        live = 0;
    }
}
