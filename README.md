ampelserver Cookbook
====================
This sets up your Rasperry PI as a dashboard machine, following these instructions:
http://alexba.in/blog/2013/01/07/use-your-raspberrypi-to-power-a-company-dashboard/


Requirements
------------

* You have your pi installed with standard Raspbian
* The ssh server running.
* X11 is set to boot up automatically.
* The startup user is called (whatever)

Attributes
----------

None so far

Usage
-----

Just include `ampelserver` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[dashboard-pi]"
  ]
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Daniel Hahn
