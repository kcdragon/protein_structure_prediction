echo OFF
for %%G in (0 1) do (
	for %%r in (0.2 0.4) do (
		for %%i in (0 1 2) do (
			ruby main.rb -G %%G -r %%r pphpphhpphhppppphhhhhhhhhhpppppphhpphhpphpphhhhh >> results.csv
			echo ON
			echo done
			echo OFF
		)
    )
)