# RemoteBackendExercise

Follow the next steps to run the project:

1. Install [asdf](https://asdf-vm.com/guide/getting-started.html#_1-install-dependencies) cli tool
2. Install asdf erlang plugin

   2.1 Install an erlang specific version:

   ```
		asdf install erlang 25.1.2
	```
3. Install asdf elixir plugin

   3.1 Install an elixir specific version:

	```
		asdf install elixir 1.14.2-otp-25
	```
4. In the root of the project run 

	```
		asdf local erlang 25.1.2
		asdf local elixir 1.14.2-otp-25
	```

5. Clone the repo 
	
	```
	git clone https://github.com/ivanhoe/remote_backend_exercise.git
	```

6. Download dependencies

	```
	  mix deps.get
	```
	
7. Create the database, execute migrations and run the seed
	
	```
	  mix ecto.setup
	```

8. Run the server

	```
	mix phx.server
	```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
