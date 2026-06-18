An (intentionally) over-engineered solution to CSU's CS430 Lab 7 Assignment.

Referential integrity fails on two commented-out transactions in activity.sql.
1) Removing Grace Slick is not a valid operation since other relations rely on that entry.
2) Adding Growing Your Own Weeds to the main library (the second time) fails because the 
    publisher id of 90000 does not already exist within the table.

It's worth noting that there is some ambiguity with how the activity prompts are written.
For example, it is unclear if "remove grace slick" means to just attempt to remove her (
as I assume is the intention) or to do everything I can in order to allow that to happen.

Full project files available: https://github.com/keinnyne000/cs430l7