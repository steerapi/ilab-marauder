-----------------------------------------------------------------------------------------
-- Firebase Class
-----------------------------------------------------------------------------------------
Server = Core.class(EventDispatcher)

-----------------------------------------------------------------------------------------
function Server:init(base_url)

   -- Create header for app-level access
   self.headers = { 
      ["Content-Type"]  = "application/json",
   }

   -- Extra arg list
   self.extraArgList = {
		apiKey = "wYOMnVBFyV8AVhynZ7RR0aN3P2XVMuXxU17IDh3i"
   }

   -- Initialize class
   self.rest = Rest.new(self, "server/server.txt")

   -- Add url
   self.rest.api.base_url = base_url

end

-----------------------------------------------------------------------------------------
function Server:callMethod(name, t, ...)
   -- Make the rest call
   self.rest:call(name, t, self.headers, self.extraArgList, nil, ...)
end
