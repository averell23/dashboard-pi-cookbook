#
# Cookbook Name:: dashboard-pi
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

package "chromium"
package "ttf-mscorefonts-installer"
package "unclutter"

directory "/home/#{node.dashboard_pi.user}/.config/lxsession/LXDE" do
  recursive true
  owner node.dashboard_pi.user
  mode '0700'
end

template "/home/#{node.dashboard_pi.user}/.config/lxsession/LXDE/autostart" do
  source 'autostart.erb'
  owner node.dashboard_pi.user
  mode '0600'
  variables :url => node.dashboard_pi.url
end

cookbook_file "/etc/lightdm/lightdm.conf" do
  source 'lightdm.conf'
  owner 'root'
  group 'root'
  mode '0644'
end

time_off = 19 - node.dashboard_pi.utc_offset
time_on = 9 - node.dashboard_pi.utc_offset

cron "Switch off monitor at night" do
  hour time_off
  minute 0
  command '/usr/bin/sispmctl -f 3'
end

cron "Switch the monitor on each weekday morning" do
  hour time_no
  minute 0
  weekday '1-5'
  command '/usr/bin/sispmctl -o 3'
end