echo OFF
for %%p in (50 100 150 200 300) do (
	for %%i in (0 1 2 3 4) do (
		ruby main.rb -p %%p ppphhpphhppppphhhhhhhpphhpppphhpphpp >> results.csv
		echo ON
		echo done
		echo OFF
    )
)