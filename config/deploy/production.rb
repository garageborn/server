server 'app01.server', user: 'garageborn', roles: %w{app ssl}
server 'app02.server', user: 'garageborn', roles: %w{app}
server 'app03.server', user: 'garageborn', roles: %w{app}
server 'worker01.server', user: 'garageborn', roles: %w{db worker}
