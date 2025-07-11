# README

 Custom Authentication & Access Control Rails App

A Ruby on Rails 7 application implementing:

-  Organization-based access control with roles (admin, member)
-  Age-based participation rules (child, teen, adult)
-  Parental consent for minors (under 18)
-  Age-appropriate content filtering

---

 Features

 Custom Authentication
- Built-in user authentication using Devise or custom auth
- Users must log in to access most features

 Organization-Based Access Control
- Users can belong to multiple organizations
- Each user has a role within an organization (`admin`, `member`)
- Only admins can manage members or content for their org

Age-Based Participation
- Age calculated from date of birth
- Users are categorized as:
  - `child` (0–12)
  - `teen` (13–17)
  - `adult` (18+)

 Parental Consent for Minors
- Users under 18 must provide a valid parent’s email
- Parent (must be a registered user) receives a dashboard to approve the minor
- Minors cannot access any content until confirmed

 Age-Appropriate Content Filtering
- Content is tagged by age group (`child`, `teen`, `adult`)
- Users only see content matching their age group
- Content belongs to an organization

---

 Models Overview

 `User`
- Attributes: `name`, `email`, `date_of_birth`, `age`, `parent_email`, `parent_confirmed`
- Logic:
  - `before_validation :calculate_age`
  - `minor?` helper method

 `Organization`
- Has many users through `OrganizationUser`
- Has many `contents`

 `OrganizationUser`
- Join model between `User` and `Organization`
- Has `role` enum (`admin`, `member`)

 `Content`
- Belongs to `Organization`
- Has `title`, `body`, `age_group` enum (`child`, `teen`, `adult`)
- Scope `visible_to(user)` filters by age

---
