//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface LabLike {
    function port(bytes32 bag, address src, address dst, uint256 wad) external;
    function move(address src, address dst, uint256 wad) external;
}

interface DewLike {
    function move(address,address,uint256) external;
    function burn(address,uint256) external;
}

// Standard surplus auction
contract Flab {
    // --- Auth ---
    mapping (address => uint256) public wards;
    function rely(address usr) external auth { wards[usr] = 1; }
    function deny(address usr) external auth { wards[usr] = 0; }
    modifier auth {
        if(wards[msg.sender] != 1) revert Err("Flabber/not-authorized");
        _;
    }

    struct Bid {
        uint256 bid; // dew bid
        uint256 lot; // rep purchasable
        address guy; // high bidder
        uint48 tic; // bid expiry time
        uint48 end; // auction expiry time
    }

    mapping(uint256 => Bid) public bids;

    LabLike public  lab; // Game Engine
    DewLike public  dew;

    bytes32 public  bag; // Bag type
    uint256 public  live; // Active flag

    uint256 public constant ONE = 1.00E18;
    uint256 public   beg = 1.05E18;  // 5% minimum bid increase
    uint48  public   ttl = 3 hours;  // 3 hours bid duration         [seconds]
    uint48  public   tau = 1 days;   // 1 days total auction length  [seconds]
    uint256 public kicks = 0;

    // --- Events ---
    event Kick(
      uint256 indexed id,
      uint256 lot,
      uint256 bid
    );

    // --- Errors ---
    error Err(string msg);

    // --- Init ---
    constructor(address lab_, address dew_, bytes32 bag_) {
        lab = LabLike(lab_);
        dew = DewLike(dew_);
        bag = bag_;
        wards[msg.sender] = 1;
        live = 1;
    }

    // --- Auction ---
    function kick(uint256 lot, uint256 bid)
        public auth returns (uint256 id)
    {
        if(kicks > type(uint256).max) revert Err("Flabber/overflow");
        id = ++kicks;

        bids[id].bid = bid;
        bids[id].lot = lot;
        bids[id].guy = msg.sender;
        bids[id].end = uint48(block.timestamp) + tau;

        lab.move(msg.sender, address(this), lot);

        emit Kick(id, lot, bid);
    }
    function tick(uint256 id) external {
        if(bids[id].end >= block.timestamp) revert Err("Flabber/not-finished");
        if(bids[id].tic != 0) revert Err("Flabber/bid-already-placed");
        bids[id].end = uint48(block.timestamp) + tau;
    }
    function tend(uint256 id, uint256 lot, uint256 bid) external {
        if(bids[id].guy == address(0)) revert Err("Flabber/guy-not-set");
        if(bids[id].tic <= block.timestamp || bids[id].tic != 0) revert Err("Flabber/already-finished-tic");
        if(bids[id].end <= block.timestamp) revert Err("Flabber/already-finished-end");

        if(lot != bids[id].lot) revert Err("Flabber/lot-mismatch");
        if(bid <=  bids[id].bid) revert Err("Flabber/bid-not-higher");
        if(bid * ONE < beg * bids[id].bid) revert Err("Flabber/insufficient-increase");

        if (msg.sender != bids[id].guy) {
            dew.move(msg.sender, bids[id].guy, bids[id].bid);
            bids[id].guy = msg.sender;
        }
        dew.move(msg.sender, address(this), bid - bids[id].bid);

        bids[id].bid = bid;
        bids[id].tic = uint48(block.timestamp) + ttl;
    }
    function deal(uint256 id) external {
        if(live != 1) revert Err("Flabber/not-live");
        if(bids[id].tic == 0 && (bids[id].tic >= block.timestamp || bids[id].end >= block.timestamp)) revert Err("Flabber/not-finished");
        lab.move(address(this), bids[id].guy, bids[id].lot);
        dew.burn(address(this), bids[id].bid);
        delete bids[id];
    }

    function cage(uint256 rad) external auth {
        live = 0;
        lab.move(address(this), msg.sender, rad);
    }
}
