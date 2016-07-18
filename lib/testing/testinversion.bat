echo OFF
for %%i in (0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5) do (
	for %%c in (0 1 2) do (
		ruby main.rb -i %%i ppphhpphhppppphhhhhhhpphhpppphhpphpp >> results.csv
		echo ON
		echo done
		echo OFF
    )
)