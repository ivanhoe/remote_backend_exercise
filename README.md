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

4. Download dependencies

	```
	  mix deps.get
	```
	
5. Create the database and migrate
	```
	  mix ecto.setup
	```

6. Run the server

	```
	mix phx.server
	```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
