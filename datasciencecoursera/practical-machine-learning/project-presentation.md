Developing Data Products: Course Project
========================================================
author: Hedley Stirrat
date: 7 June 2020
autosize: true

<font size='22'>Financial independence/early retirement calculator</font>

<style type="text/css">
body > div > div.slides > section.present > div > font > pre > code {
  font-size: 16px;
}

</style>

What is FI/RE?
========================================================

Financial independence/early retirement is a goal for many people. However,
there are a lot of factors that could contribute to or detract from the
accumulation of wealth for financial independence.

For example, if you saved an extra $5000 per year, how much sooner would you
be financially independent?

Of course, it's not easy to visualise the end goal when your retirement
could be twenty or thirty years away. And that's where this Shiny app
comes in handy: You can use it to project the time it would take for you
to reach financial independence, and modify some of the contributing factors
to see how you could reach that goal earlier!

How it works
========================================================
You'll be asked to provide a few simple inputs. For example, what annual
income are you targeting from your investments once you've retired? How much
are you intending to contribute toward your retirement accounts per year?

The app takes these inputs and calculates your predicted retirement year,
how close to financial independence you are, and what that path looks like.

Then, you can play around with the numbers, and see what you can do to get there earlier!



What's going on behind the scenes?
========================================================
The financial independence/early retirement predictor is based on this simple
function that calculates compounding interest from your investment accounts:
<font size='10'>

```r
# function to calculate number of years until retirement
cmpd_interest_until_target <- function(rate, initial, target, injection) {
	dat <- data.frame(year = 0, principal = initial)
	while(dat[nrow(dat), 'principal'] < target) {
		this_year <- dat[nrow(dat), 'year'] + 1
		this_principal <- dat[nrow(dat), 'principal'] + rate * dat[nrow(dat), 'principal'] + injection
		dat <- bind_rows(dat, data.frame(year = this_year, principal = this_principal))
	}
	return (dat)
}
```
</font>
To see what it looks like, let's assume the following: a 7% annual rate of return,
an initial principal of \$50000, a retirement target of \$1.5M, and annual contributions
of \$40000. How long will it take for us to retire?

How long will it take?
========================================================


![plot of chunk unnamed-chunk-3](project-presentation-figure/unnamed-chunk-3-1.png)

***
Looks like financial independence is about 17 years away!
But what if we increase our contribution rate? Or
realize we don't need to have such a high income when we're retired?
To try it out for yourself,
head on over to

**https://heds1.shinyapps.io/fire-calc/**
