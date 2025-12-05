# Goal of an "As Code" Environment

Our goal is to show the ability to create a set of core Grafana Cloud components using Terraform as it is a common request from our biggest and more sophisticated Grafana users.
Users can get practical experience of how to get started with their RBAC strategy by following the steps below.

The following elements will be created using code:

* Advanced Authentication, ie Teams with External Group Sync (SAML);
* A custom RBAC role with Reporting;
* Data Sources;
* Dashboard Folders;
* Dashboards;
* Alerts;
* Contact Points;
* Notification Policies;
* Alert Silence Rules; and
* A custom LBAC rule.

Access to all of these elements depends upon the user's access rights. When a user logs in for the very first time, they will only have access to a limited, curated set of content.

# Prerequisites

There are 7 prerequisites for this setup. You only need to perform these pre-requisites once.

1. Install Grafana's latest [Terraform provider](https://github.com/grafana/terraform-provider-grafana/releases).

2. Do a `git clone https://github.com/mikempx/grafana-as-code.git`

3. Create a new Grafana Cloud account by going to https://grafana.com/get.

4. Once your Grafana Cloud environment has been created, generate a `Service Account` with Admin rights and a token. In the picture here, the service account is called "TERRAFORM", the Admin role is applied, and a token called "tf" was generated, starting with glsa_.

![Service Account](/images/serviceaccount-TF.png)   

5. Copy the grafana url and the token to your provider.tf file and then run the command, `terraform init`.

6. **Create your OKTA environment**. Details in the [OKTA Details](https://github.com/mikempx/grafana-as-code/blob/main/readme.md#okta-details) section below. You will be surprised how easy it is to configure OKTA for the first time.

7. Set up SAML SSO on your stack (Administration...Authentication...SAML) . Details in the "More Details" section below.

## Possible Scenario
Details on the possible scenario are explained in the [More Details](https://github.com/mikempx/grafana-as-code/blob/main/readme.md#potential-talk-track) section, but can be summarized in the following picture.
![Create App](/images/rbac.png)

### Step 1 - Describe the Terraform files we have

In our working directory, we have ~14 terraform files.

The most important file is the provider as it gives us access to our Grafana Cloud instance.

Next, we have a set of 3 datasources. Each one is configured a bit differently based on the credentials. I'll show you the Prometheus one as an example.

show the contents of `datasourceprometheus.tf` - quickly.

We have a file called teams. In Grafana, Teams are simply groups of users with common permissions.

In this teams file, we do 3 things:

(1) we name our team;

(2) we automatically LINK our team to agroup defined in our IAM provider; and

(3) we optionally set some group preferences.

show the contents of teams.tf during your talk track above.

We also have an important one called `apply_folder_permissions`. This one is more involved so let's open it up and see what it does.

(1) First, it creates 3 folder objects - one per team.

(2) It then imports 3 dashboards and places those dashboards into the folders. So you can see, for example, in the 2nd line, we create a resource called ITcollection. Then, on line 33 we import the itdash.json dashboard and on line 36 we reference that folder.

(3) The second half of the file then adjusts the permissions of the folders, referencing the team objects we created in our teams terraform file. One important thing to note is that we also add a permission of Admin. By default, all dashboards in a folder can be also Edited by Editors and Viewed by Viewers. By adding just Admin, we are taking a "Least Privilege" approach to who can access the data.

show the contents of `apply_folder_permissions.tf` during your talk track above.

Here are essentially what the other files do:

* The 3 *alerts_* files have our alert definitions;
* *notif* has an automated contact point, a mute policy, and a notification policy tree;
* *datasource_perms*, similar to our folders, has access locked down so that one certain teams can access the underlying data.
* We also want to hide the administrative folder Grafana Cloud provides us, and so there's a file to make it an Admin-only folder;
* We also have 3 json dashboard files - one dashboard per team; and finally
* There's *userrbac.tf* which contains a granular, role-based access controls for your users.
  
### Step 2 - Run Through your unpopulated Cloud Environment

So before we apply our code, let's do a quick run-through of the cloud environment.

*Tip:* "Bookmark" the following: Users, Teams, Data Sources, Alert Rules, Dashboards, Authentication.

At minimum:

(1) Go to Dashboards and so that there are none except for the GrafanaCloud folder with lots of stuff in it. NOTE: you may want to move or delete the default "OnCall Insights" dashboard as, IMHO, it should really be in the GrafanaCloud folder (or not present altogether if IRM is not in use).

(2) Go to Administration->Users and access->Teams along with Users and show that they are blank.

(3) Go to Administration->Connections->Data source and show that there are none who start with double dash "--" preceding their name.

There are also no contact points, notification policies or mute timings in this brand new environment but I think by now you probably believe me that they aren't going to be there.

So without further adieu, let's run it!

### Step 3 - Run Terraform and describe what is available to Finance users

`terraform apply` and to confirm, type `yes`

First, we will log in as a Finance person for the FIRST TIME EVER.

`frank.ford@example.com` Note: all user passwords are `Grafana123!` for ease of recall.

* You see that Frank lands on his custom dashboard with all of the Finance details his team is responsible for.

* Within this custom dashboard, let's focus on the graph, `Web Site Latency by Data Center (ms)`.  In the graph, we see latency for the location "NorthVirginia" only.  We are leveraging `label based access controls` or **LBAC** to limit the data the Finance team is allowed to see for this data source.

* Clicking on dashboards, he sees that he has only ONE folder: FINANCE'S automated folder
* Clicking on the Grafana Logo to open the menu, we can see that Finance also has access to alerts. Clicking on Alert Rules, you see that they have one folder with one alert defined.

Let's log out and see what it looks like for the Marketing team - again, for the FIRST TIME EVER.

### Step 4 - Login as mary.martin@example.com and describe what is available to Marketing users

Logout and login as `mary.martin@example.com` (Grafana123!)

Logging in, you first notice that Marketing lands on their web site tracking dashboard powered by sending NGINX logs to Grafana Cloud.

Clicking on dashboards, they too only have one folder, and

When we open the menu, we see that Marketing also has Alerting, but clicking on the Alert Rules, the one alert definition is tied to their data sources on not anyone else's.

Finally, notice that Marketing has the Reporting feature (under Dashboards), while Finance did not.

Now let's log in as an administrator.

### Step 5 - Login as yourself to describe what is available to Administrators

Log in as yourself in Grafana.com OR login as `ian.ally@example.com` (Grafana123!)

When we open the menu, you can see we have access to all features and data sources.

* First, let's go back to the Finance dashboard.  You see in the `Web Site Latency by Data Center (ms)` graph that there are 3 signals now.  Since we have administrative privileges, `Label Based Access Controls` are not in play anymore.

* Next, if I go to Alert rules, I can not only see the Alert rules for Finance and Marketing, I can also see a folder for Billing Alerts. If I open that up, I can see that 3 of the 4 alerts are paused at the moment. 

* Also, if you stay on this page and filter our alerts on Contact point, you can see that all of our alert rules are linked to the new Contact Point.

* Finally, I can click on Alerting at the top and go to Notification policies, and you can see the entire logic tree that we've implemented as code.

### Step 6 - Make code changes, reapply, and see the power of "o11y as code"

We have 2 changes to make in our demo here.

(1) The first is that we need to "unpause" those billing alerts; and
(2) the second is that I forgot that Marketing needed access to the Kubernetes application. So let's go make those changes.

Open up `alerts_billing.tf` and search for **is_paused = true**. Change at least one of the 4 entries to false.

**OPTIONAL:** Open up `userrbac.tf`. Describe that we have two custom roles in this file. The top half is tied to the Finance team, but the bottom is tied to the Marketing team. In the file, the K8s app is properly defined, but the bottom - where we apply the role to the Marketing team is commented out. Uncomment those 5 lines AND *increment the version number* of the grafana_role for additional_apps by 1.

Re-run `terraform apply`

Now that we've made our changes, let's log in to see the effects.

Log in as yourself in Grafana.com and go straight to `Alerts & IRM > Alerting > Alert rules` and open the `Billing Alerts` folder. The alerts are now running.

* So the value of that is if your teams are doing some testing and just want to be sure there will be no false positive alerts being sent, it is very, very simple to make a change as code to pause your alert evaluations, do your testing, and then turn them back on as code when you are done. Let's now see the effects of applying the custom RBAC rule for Kubernetes to the Marketing team.

logout and log back in as `mary.martin@example.com` (Grafana123!). Click on the Grafana logo to open the menu and <tada> there's the K8s app.

# OKTA Details
To get started as a new user of OKTA, go to https://developer.okta.com/signup/ and choose `Access the Okta Integrator Free Plan`.  Sign up and get logged into your OKTA integrator instance. 
Once logged into OKTA, make sure you are in the `Okta Admin Console`, the two toggle button on the upper left.

Go to Applications > Applications and `Create App Integration`.  Choose `SAML 2.0` and click *Next*.
1. In General Settings, provide an App Name of **Grafana Cloud** and click next.
    ![Create App](/images/1OKTA-SAML.png)

2a. In SAML Settings, set Single sign-on URL to `https://<your Grafana Cloud URL>/saml/acs`

2b. Also, set Audience URI to `https://<your Grafana Cloud URL>/saml/metadata`
 ![SAML settings](/images/2OKTA-SAML.png)
3. Scrolling down, set the following **Attribute Statements**:

login -> `user.login`

email -> `user.email`

displayName -> `user.firstName`

Set the following **Group Attribute Statement**:

groups -> filter (Matches regex) -> `.*`
 ![SAML settings](/images/3OKTA-SAML.png)
Click on `Next` and `Finish`.

4. In your new Grafana Cloud "Application" within OKTA, click on the `Sign On` tab.  It contains the Metadata URL you will paste into Grafana later.
 ![SAML settings](/images/4OKTA-SAML.png)
5. Scrolling up within OKTA, go to Directory -> Groups and then click on **Add Group**.

Add groups `Finance`, `Marketing`, and `IT`.  Note that there's already a default group called `Everyone`.

![SAML settings](/images/5OKTA-SAML.png)

5a. For each new Group, go to the `Applications` tab and click on `Assign Applications`. Click on the `Assign` button next to `Grafana Cloud`.
![SAML settings](/images/5dOKTA-SAML.png)

5b. Go to Directory -> People and then **Add Person**. Make sure you:
* Add their Group.  In the picture below, we align the `Marketing` group to the user's profile.
* Check/enable on *I will set password*. To make it simple to remember, I set all passwords to `Grafana123!`

* Uncheck/disable *User must change password on first login*

For Marketing, I create at least one user - `mary.martin@example.com`

For Finance, I create at least one user - `frank.ford@example.com`

For IT, I create at least one user - `ian.ally@example.com`

![User creation](/images/5bOKTA-SAML.png)
![Users in OKTA](/images/5cOKTA-SAML.png)

5. Going back to Applications > Applications and your new `Grafana Cloud` Application within OKTA, clicking on the `Assignments` tab, you should see that all groups have been assigned to the Grafana Cloud application.  Also, when clicking on a Group name, you should see that the users are properly assigned to their groups as well.
![User creation](/images/5aOKTA-SAML.png)

6. Moving over to Grafana Cloud, go to **Administration -> Authentication -> SAML**
7. In Grafana Cloud Setup SAML single sign on step 1, for Display name, type `OKTA`and click on `Next: Sign requests`
8. In Grafana Cloud Setup SAML single sign on step 2, click on `Next: Connect Grafana with Identity Provider`
9. In Grafana Cloud Setup SAML single sign on step 3, paste the Metadata URL generated from (4) above into this empty field and click `Next: User mapping`
![Users in OKTA](/images/6OKTA-SAML.png)
10. In Grafana Cloud Setup SAML single sign on step 4, configure the `Assertion attributes mappings` and `Role mapping` as shown here.  Most important to note is that we will be taking a LEAST PRIVILEGE approach as the group `Everyone` will have no default role whatsoever.  All access rights will be granted through Team Sync.  
![Users in OKTA](/images/7OKTA-SAML.png)    
11. Click on `Test and enable` and then `Save and enable`.
12. Open an Incognito Window on your browser and visit your Grafana Cloud login.  It takes a minute or two for enablement, but you will eventually have two login buttons - one of which will state, `Sign in with OKTA`.

That's it! Your Grafana Cloud instance is now configured with SSO and you can perform your as-code deployment.

# More Details

## Familiarize yourself with the different Terraform (tf) files. cd to grafana-as-code directory and use it as your working directory. A description of the files:
* `provider.tf`: defines (a) the minimum provider version of 4.1.4 and connectivity settings to your Grafana instance.
EDIT THIS FILE with your Service Account token and your new Grafana URL.
* `alerts_billing.tf`: defines 4 alerts, 3 of which are in a "Paused" state. In your demo, you may want to modify this file, enable all alerts, and "terraform apply"
* `apply_folder_permissions.tf`: imports our 3 dashboards into 3 newly created folders and applies Team access rights to them. Also of note that we remove the generic "View All" access to the folder so that only users with proper access can see dashboards in these folders.
* `change_access_to_grafana_cloud_folder.tf`: removes the generic "View All" access to the folder
* `datasource_perms.tf`: provides query access to only the Marketing team for NGINX/Loki logs and only the Finance team to the TestData datasource.
* `datasourceloki.tf`, `datasourceprometheus.tf`, `datasourcetestdata.tf`: Adds our Prometheus and Loki 101 classroom instances as datasources, and adds a generic TestData datasource as well. Each one is configured differently depending upon credentials.
* `financedash.json`, `itdash.json`, `marketingdash.json`: Our 3 dashboards.
* `notif.tf`: Adds a contact point (email); a mute timing (monday); and a notification policy tree referencing the contact point and mute timing. 
* `teams.tf`: This creates your user teams and applies the LDAP groups to the teams as an External Group Sync.
* `userrbac.tf`: Defines custom user roles. 


## Possible Scenario
Here’s our current situation:
You are a new Grafana Cloud customer and have been tasked with setting up Grafana Cloud “as code” as the company has a strong DevOps and SRE culture.
Your security team has already integrated your IAM provider, OKTA, with Grafana Cloud.  
It is up to you to set up the rest of Grafana Cloud via Terraform.

Regarding your internal "customers" - Marketing, Finance, and IT - their RBAC Requirements are as follows:

* Automated access for their users. They don’t want to call you to add a new user.
  
* Custom dashboards in which they’ve already shared with you.
  
* Dashboards should not be shared with other teams.
  
* Alert definitions should not be shared with other teams.
  
* Reporting - Marketing needs reporting but not Finance.
  
* All logs entering their system cannot be seen by Finance.  However, Finance is required to see a particular set of data coming from Northern Virginia.
  
* All of this needs to be maintained as code.  


# Post Demo

Be sure to run `terraform destroy` to delete your resources on your cloud instance.

Delete your cloud stack so that it doesn't cost the company more than needed.

Please feel free to provide feedback and improvements we could make!!!!!
