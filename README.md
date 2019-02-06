# Description

This Gem provides all the logic to connect to a Stomp Client, subscribe a worker and wait for messages coming on the given event.

# How to use it

To get it working you need a *config/tails.yml* file with all the configurations to Stomp (See samples folder). Also you would have to implement a class with two methods and inherit from `Tails::Worker` (Look at samples folder). To locate this workers this Gem will parse the given namespace, i.e: Sonic::Worker1 means to look for `worker1.rb` at `sonic/worker1.rb`. This also supports snakes camel, so `SonicModule::MyWorker` will be parsed as `sonic_module/my_worker.rb`.

With all the configurations set up then execute the tails command as follow:

`bundle exec tails -n Sonic::DeviceCreated`

The parameter `-n`refers to the namespace, this is your worker module + class. This can also be set at tails.yml setting a key as follow:

```
namespace: 'Sonic::DeviceCreated'
```
