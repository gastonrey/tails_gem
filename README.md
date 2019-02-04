# Description

This Gem provides all the logic to connect to a Stomp Client, subscribe a worker and wait for messages coming on the given event.

# How to use it

To get it working you need a *tails.yml* file with all the configurations to Stomp (See samples folder). Also you would have to implement two methods when inherinting from `Tails::Worker` (Look at samples folder).
With all the configurations set up then execute the tails command as follow:

`tails -n Sonic::DeviceCreated`

The parameter `-n`refers to the namespace, this is your worker module + class. This can also be set at tails.yml setting a key as follow:

```
namespace: 'Sonic::DeviceCreated'
```
