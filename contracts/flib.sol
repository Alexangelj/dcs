// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/*
    Loot awaits in victory and slashing awaits in defeat
*/

interface LabLike {
    function port(bytes32 bag, address src, address dst, uint256 wad) external;
    function dew(bytes32 bag, address src) external view returns (uint256);
}

contract Flib {
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
    struct Dip {
        uint256    lot; // dew up for grabs
        bytes32    toy; // attacker's collateral
        uint256    bid; // attacker's collateral size
        address    ape; // attacker
        address    fox; // defender
        bytes32    boo; // attacker moves hash [keccak256]
        bytes32    bow; // defender moves hash [keccak256]
        uint256[5] woo; // attack moves revealed
        uint256[5] wow; // defender moves revealed
        uint48     tic; // commit timer start
        uint48     end; // round end timestamp
        int256     tab; // total score for round
    }

    mapping(uint256 => Dip)     public dips; // all game rounds
    mapping(bytes32 => uint256) public pies; // acceptable bag types

    LabLike public  lab; // Game Engine
    bytes32 public  bag; // Bag type
    uint256 public  live; // Active flag

    uint256 public  kit = 5; // amount of moves
    uint48  public  ttl = 12 hours; // move timer     [seconds]
    uint48  public  tau = 1 days; // round duration   [seconds]
    uint256 public  kicks = 0; // round nonce

    // --- Errors ---
    error Err(string msg);

    // --- Events ---
    event Kick(address indexed ape, address indexed fox, uint256 lot, bytes32 indexed toy, uint256 bid);

    // --- Enums ---
    enum Move {Focus, Attack, Parry, Guard, Spell, Block}
    
    // --- Init ---
    constructor(address lab_, bytes32 bag_) {
        lab = LabLike(lab_);
        bag = bag_;
        wards[msg.sender] = 1;
        live = 1;
    }

    // --- Admin ---
    function file(bytes32 bag_, bytes32 what, uint256 data) external auth {
        if(what == "pies") pies[bag_] = data;
        else revert Err("Flibber/file-unrecognized-param");
    }

    // --- Round ---
    function kick(address ape, address fox, uint256 lot, bytes32 toy, uint256 bid) external auth returns (uint256 id) {
        if(kicks >= type(uint256).max) revert Err("Flibber/overflow");
        if(pies[toy] != 1) revert Err("Flibber/invalid-bag");
        id = ++kicks;

        dips[id].lot = lot;
        dips[id].ape = ape;
        dips[id].fox = fox;
        dips[id].toy = toy;
        dips[id].bid = bid;
        dips[id].end = uint48(block.timestamp) + tau;

        emit Kick(ape, fox, lot, toy, bid);
    }

    function tick(uint256 id) external {
        if(dips[id].end >= block.timestamp) revert Err("Flibber/not-finished");
        if(dips[id].tic != 0) revert Err("Flibber/move-already-placed");
        dips[id].end = uint48(block.timestamp) + tau;
    }

    function wage(uint256 id) external {
        if(msg.sender != dips[id].ape) revert Err("Flibber/wage-not-ape");
        lab.port(dips[id].toy, msg.sender, address(this), dips[id].bid);
    }

    function make(uint256 id, bytes32 hue) external {
        if(lab.dew(dips[id].toy, address(this)) < dips[id].bid) revert Err("Flibber/no-wage");
        if(dips[id].ape == address(0)) revert Err("Flibber/ape-not-set");
        if(dips[id].tic <= block.timestamp || dips[id].tic != 0) revert Err("Flibber/already-finished-tic");
        if(dips[id].end <= block.timestamp) revert Err("Flibber/already-finished-end");

        if(msg.sender != dips[id].ape) {
            if(dips[id].bow != bytes32(0)) revert Err("Flibber/already-set-bow");
            dips[id].bow = hue;
        } else {
            if(dips[id].boo != bytes32(0)) revert Err("Flibber/already-set-boo");
            dips[id].boo = hue; 
        }

        dips[id].tic = uint48(block.timestamp) + ttl;
    }

    function show(uint256 id, bytes32 key, uint256[5] calldata moves) external {
        if(dips[id].boo == bytes32(0)) revert Err("Flibber/boo-not-set");
        if(dips[id].bow == bytes32(0)) revert Err("Flibber/bow-not-set");
        if(dips[id].end <= block.timestamp) revert Err("Flibber/already-finished-end");
        if(moves.length != kit) revert Err("Flibber/moves-length");

        bytes32 hue = msg.sender == dips[id].ape ? dips[id].boo : dips[id].bow; 
        if(pack(key, moves) != hue) revert Err("Flibber/wrong-hash");

        if(msg.sender != dips[id].ape) {
            if(dips[id].wow.length != 0) revert Err("Flibber/already-set-wow");
            dips[id].wow = moves;
        } else {
            if(dips[id].woo.length != 0) revert Err("Flibber/already-set-woo");
            dips[id].woo = moves;
        }
    }

    function play(uint256 id) external {
        if(dips[id].woo.length == 0) revert Err("Flibber/woo-not-set");
        if(dips[id].wow.length == 0) revert Err("Flibber/wow-not-set");

        uint256[5] memory woo = dips[id].woo;
        uint256[5] memory wow = dips[id].wow;

        int256 tally;
        for(uint256 i; i < kit; i++) {
            // play the game
            uint war = woo[i];
            uint wit = wow[i];
            tally += compare(Move(war), Move(wit));
        }

        dips[id].tab = tally;
    }

    function loot(uint256 id) external {
        if(dips[id].tic == 0 || (dips[id].tic >= block.timestamp || dips[id].end >= block.timestamp)) revert Err("Flibber/not-finished");
        int256 tally = dips[id].tab;

        address guy;

        if (tally > 0) {
            guy = dips[id].ape;
        } else {
            guy = dips[id].fox;
        }

        lab.port(dips[id].toy, address(this), guy, dips[id].bid);
        lab.port(bag, address(this), guy, dips[id].lot);
        delete dips[id];
    }

    function cage() external auth {
        live = 0;
    }

    // --- View ---
    function compare(Move war, Move wit) public pure returns (int256) {
        if(war == Move.Focus) {
            // wins point against attacks
            if(wit == Move.Attack) return 1;
            // loses point if aganst parry
            else if(wit == Move.Parry) return -1;
            // neutral if nullified from block
            else if(wit == Move.Block) return 0;
            // else wins point
            else return 1;
        } else if(war == Move.Attack) {
            // wins point against parrys
            if(wit == Move.Parry) return 1;
            // loses point if against focus attack
            else if(wit == Move.Focus) return -1;
            // neutral if nullified from spell
            else if (wit != Move.Spell) return 0;
            // else wins point
            else return 1;
        } else if (war == Move.Parry) {
            // wins point if against focus attack
            if(wit == Move.Focus) return 1;
            // loses point if against attack
            else if (wit == Move.Attack) return -1;
            // neutral if nullified from guard
            else if (wit == Move.Guard) return 0;
            // else wins point
            else return 1;
        } else if (war == Move.Block) {
            // wins point if guarded
            if(wit == Move.Guard) return 1;
            // lose point if against spell
            else if(wit == Move.Spell) return -1;
            // else neutral
            else return 0;
        }  else if (war == Move.Spell) {
            // win point if blocked
            if(wit == Move.Block) return 1;
            // lose point if against guard
            else if (wit == Move.Guard) return -1;
            // else neutral
            else return 0;
        } else if (war == Move.Guard) {
            // wins point if spelled
            if(wit == Move.Spell) return 1;
            // loses point if against block
            else if (wit == Move.Block) return -1;
            // else neutral
            else return 0;
        }

        return -1;
    }

    function pack(bytes32 key, uint256[5] calldata move) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(key, move));
    }
    
}