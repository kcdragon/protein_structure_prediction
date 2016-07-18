echo OFF
for %%m in (0.05 0.1 0.2 0.3 0.4) do (
	for %%i in (0 1 2 3 4) do (
		ruby main.rb -m %%m ppphhpphhppppphhhhhhhpphhpppphhpphpp >> results.csv
		echo ON
		echo done
		echo OFF
    )
)