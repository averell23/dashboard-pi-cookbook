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
package "x11-xserver-utils"
package "tzdata"
package "liblockdev1"

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

template "/usr/local/bin/monitor_control" do
  source 'monitor_control.sh.erb'
  mode '0755'
end

cookbook_file "/etc/lightdm/lightdm.conf" do
  source 'lightdm.conf'
  owner 'root'
  group 'root'
  mode '0644'
end

# See instructions at http://www.raspberrypi.org/phpBB3/viewtopic.php?f=64&t=7570
remote_file "/tmp/cec.deb" do
  source "http://sourceforge.net/projects/selfprogramming/files/libCEC.deb/libcec_2.1.0-1_armhf.deb/download?use_mirror=freefr&use_mirror=netcologne"
end

execute "dpkg -i /tmp/cec.deb"
 
template "/etc/timezone" do
  source "timezone.conf.erb"
  owner 'root'
  group 'root'
  mode 0644
  notifies :run, 'bash[dpkg-reconfigure tzdata]'
end

bash 'dpkg-reconfigure tzdata' do
  user 'root'
  code "/usr/sbin/dpkg-reconfigure -f noninteractive tzdata"
  action :nothing
end

cron "Switch off monitor at night" do
  user 'pi'
  hour 19
  minute 0
  command '/usr/local/bin/monitor_control off'
end

cron "Switch the monitor on each weekday morning" do
  user 'pi'
  hour 9
  minute 0
  weekday '1-5'
  command '/usr/local/bin/monitor_control on'
end
