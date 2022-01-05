GM

# my christmas notes

## basically my entire process

Maybe more than two players have to play against the level.

One player stakes, the other bets against.

What do they play?

Planets in DF are kind of like levels. Players play against each other by sending a common resource to it. Some players boost the power of that resource. Time is a factor in both scenarios since energy must move across a distance. There’s a space-time element which is important in that scenario.

Planets have different stats and regeneration rates. Its pretty simple actually.

We need something extremely simple like this.

The wolf game was also a game with this element of pvp.

On-chain pvp and pve. Dungeons and farming.

So cool.

Duel maybe?

Need to get priority. Attack and defend. Rock Paper Scissors style.

This would quickly turn into a gas guzzling auction, to get these transactions in. Maybe you can have previously queued moves.

Ah what if a “turn” lets you do multiple moves ahead of time. State would need to not overlap, so both the move txs go through.

Okay that’s pretty interesting.

Cause the on-chain history would reveal moves.

Active levels are unpaused, and the level creator must play against the user for it.

Maybe the highest bidder gets to play the level.

The effects would move sequentially through the stack of moves, how the hell would you implement that?

Example: A is Attacker D is defender R is result

A1. Attack
D1. Defend
R1. Defender -defense
A2. Attack
D2. Attack
R2. Defender -health
A3. Attack
D3. Parry
R3. Attacker -health
A4. Defend
D4. Attack
R4. Attacker -defense
A5. Spell
D5. Attack
R5. Both -health
A6. Spell
D6. Counter
R6. Attacker -shield

Attackers get priority so two offensive moves result in attackers favor.
Defenders get home advantage, so two defensive moves result in defender favor.

Spells are wild cards?

Attack is vulnerable to Parry
Parry is vulnerable to Defend
Spell is vulnerable to Counter
Defend is vulnerable to Spell
Counter is vulnerable to Attack

Vulnerable is health terms
Other cases defenses are subtracted
Once shields are exhausted, health is used in place

So the process:

Dungeon Master “DM”:

- Stakes a bag of loot
- Sets the config (fees, etc.) - init
- Activates or deactivates a level - mode
- Participate in a round to defend level - join
- Activates or deactivates Sponsors - team
- Boost level with staked items - bind
- Start a new round - open
- Begin a round - draw

Sponsors:

- Contribute loot to pot - fund
- Earn a % of the bets pro-rata to pot size
- Boost the level with items - care

Player:

- Places a bet, highest bet gets accepted to play on a rolling basis - wage
- Player has x amount of time to commit to a move set, depending on config - make
- Commitment period wait time is y, depending on config
- Once both moves are committed, each player must reveal - show
- On both reveal, anyone can call “play” - play
- On play, set of moves are executed against each other
- Win takes a spoil of the pot, lose will have the bet slashed from credits - loot
- Player reputation increases regardless, depending on win or lose, proportional to amount bet, total pot size, config (implied difficulty), and total pot size

Config

- Auction period - time before a round starts to accept bids
- Round period - time between winning a bid and committing a moves
- Fee - % of fees earned by sponsors, paid out from won bets
- Min Rep - minimum reputation to sponsor
- Max sponsor - maximum loot to sponsor
-

Other notes

Maybe a single move is revealed? Which the player gets to play off of. Or defender is limited to supplying 9 new moves for example.

Spells good be cool

“Foresight” - reveal next move and alter the next move to counter it favorably.

Items could have durability.

Items could be in an AMM with currency, so they are priced on chain.

Super gas optimized. Maker variables. Layer 2 native.

——

So we could have a few game states and have contracts for each state:

1. Config and setup - fig
2. Bid phase - Auctions
3. Round phase - ?
4. Settlement (play) phase - war?

Engine - Game loop?

Okay so out “Bid round” is the Flub - an auction.
Winner needs to get something, a ticket, to spend in the den.

Round of a game + settlement has a phase.

Yeah this should be its own similar contract.

So auction has a few things:

- Highest bid
- Bidder of the highest bid
- Bid end
- Auction end
- User ?
- Recipient to output of winning bid
- Max bid

And a few stateful variables that affect auctions:

- Min bid increase
- Bid duration
- Auction length
- Increment of auction nonce

What does a game round have?

- An ape - attacker
- A fox - defender
- Ape move commit hash
- Fox move commit hash
- Ape moves
- Fox moves
- Round end timestamp

What are the games stateful vars?

- Amount of moves
- Game round length
- Increment of game round nonce

Round

- Dive - Start round
- Surf - Restart round

Combat mechanics:

- Defender gets positive points
- Attacker gets negative points
- Neutral is 0
  Attacks against attacks to gain points:
- Attacks beat parry
- Focus attacks beat attacks
- Parry beats focus attacks
  Defend against defense to gain points:
- Spells beat Defense
- Guards beat Spells
- Defense beats Guards
  Defend against attacks to stay neutral:
- Defend nullifies focus attacks
- Guard nullifies parry
- Spells nullify attacks

Cup - Handles rewards distribution based on score, bid, config, ante.
Vatlike - Hanldes rewards distribution. Yeah this should be the engine.

Lab - The Game Engine

- Admin fns
- Functions to switch flags - team and mode
- Move ace - mail
- Manipulate collateral? Reputation? - port
- Settle stake amounts
- Liquidated (lost a round) - loot
- Attach and item - bind
- Sponsor - fund

Bag - loot type in the level
Oft - individual position in the level?

Okay so we have:

Lab - Game Engine with staked amounts, bag types, gm positions?
Flub - bid auction mechanism to kickoff a round
Den - similar to bid auction phase system but for the game round
Fig - config?

Could use positions as both dungeon masters and as accumulating loot.

I.e. open a position, put some collateral, get currency to back levels. On liquidations, players who won get ur loot.

Den

Fund - Add a lot of Bag gems to it -> moves lot of collateral from msg.sender
Dive - Start a game round
Surf - Restart a game round
Wage - Player puts up wager of collateral toy in amount pep
Make - Commit a move hash
Show - Reveal moves
Play - Settle moves
Loot - Settle rewards -> moves lot of collateral to guy
Compare - view - Game play
Pack - hash fn for commit

Flub

Maybe this is where you earn rep to play game rounds?
Kick - Start bid phase
Tick - restart bid phase
Tend - Submit bid
Deal - Settle bid and receive collateral?

Lab
Mode - toggle live (one time)
Team - toggle club
Fund - Add dew
Mail - transmit Rep
Port - transmit dew
Bind - TBD
Loot - Manipulate dew + rep?

Flow

GM

- Add collateral (items)
- Get Rep
- Stake collateral to earn rep over time
- Use rep in market or for other game masters

Player

- Get rep somehow
- Spend rep on bids
- On winning bid, get access to den somehow (maybe through collateral?)
- Compete for dew using your own dew
- Maybe dew collateral has a multiplier so not as much is risked as is up for grabs
- Use collateral types to play in rounds

Player draft:

- Get rep (on market, collateral minting, etc.)
- Spend rep on bids
- Win an auction, receive collateral
- Use collateral in Dens which accept it as a wager
- Win game rounds to win more bags, to mint more rep, to get more bags.

Good cycle. Good project.

Maybe Den can have the ward whitelist select dews, that way they can kind of choose what they want to earn in.

Pub

- kick round start
- Kick bid start
- Cage both den and flub

Flub - Selling rep for collateral
Flab - Playing collateral for collateral

Flap - Surplus auction - Sell stable coins for Mkr - sell rep for MKR? - flab
Flop - Debt auction - Mint MKR sell for stable - mint loot for rep
Flip - Collateral auction - Sell collateral for stable - sell loot for rep - play game - flip

Lab -> zoo -> flip.kick

User -> bite -> zoo

Zoo

- Kick round start

A round needs:

- A prospective collateral position
- An ape attacker
-

Game rounds occur in the Flib

- Flip has a stateful bag type (i.e. 1 flip contract per underlying loot)
- Total dew amount of bags up for grab
- Flag for active
- Lab contract
- Amount of moves
- Move timer
- Round duration
- Nonce to track rounds
- Rep is spent to play in rounds? No, collateral is wagered
- Acceptable collateral types as wagers

Each Game has its own struct “Dip”

- Amount of this Flip’s type up for grabs
- A bag type the attacker staked
- An amount they staked
- An attacker
- A defender
- Commit hashes for both players
- Moves for both players
- Commit, move timer, start
- End timestamp of round
- Total score at the end of a round

Lab holds data structs for the item types and level types

Bag - Item Type

- “Rate”, multiplier on attacker’s stake
- “Ceil”, ceiling of rep which can be generated from it
- “Wis”, total sum of item type in existence
- “Gum”, total sum of debt for item in existence

What would the level have?

Cup - Level Type

- wis, amount of collateral
- gum, amount of deb

Flab is a surplus auction which will pay out stable coins in exchange for MKR bids

We can make it pay out rep in exchange for xxx

Flip is a collateral auction which users can spend rep on.

This makes sense, since users could make their own collateral vaults to mint rep, to use to play in other games.

Flip is the spend rep, play game, get collateral.

Flab therefore is the way to also get rep, by selling XXX.

Therefore we need to make a FLOB to mint the xxx.

When playing a game, do you risk your loot, or your currency?

Losing loot is not fun. It would be tough to get some, risk it, and lose it. Rather than just getting and spending rep.

Collateral shakers would be earning rep, and maybe earning credits for xxx? But that’s kind like lm program

But staking loot for a round, then the game engine could maybe let you utilize those assets. That’s a bit more interesting so ill keep it that way for now.

Hmm okay so maybe this:

1. Add collateral
2. Mint rep
3. Spend Rep on Rounds (Flip) to get collateral
4. Sell dew (Flab) to get rep

Need:

- Functions to mint dew and sell it for rep?
- Functions in lab to mint rep for collateral
- Functions to add collateral
- Functions to move collateralÍ

Starting a round requires:

- Attacker
- Defender
- Lot size
- Bag
- Bid in bag

Defender will determine which vault is tapped into.

Vault - game level - not game level, more like an instance - has a multiplier to multiply the bid by the user by.

So the cup, game level owner, is the fox, lot is a function of the game levels total balance, pep is the bid
