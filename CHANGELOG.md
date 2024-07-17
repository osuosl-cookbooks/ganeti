6.1.0 (2024-07-17)
------------------
- Remove support for CentOS 7

6.0.0 (2024-02-29)
------------------
- Refactor to be resource driven cookbook

5.0.0 (2021-07-06)
------------------
- Set unified_mode for custom resources

4.0.0 (2021-04-12)
------------------
- Update Chef dependency to >= 16

3.1.0 (2020-08-25)
------------------
- Chef 16 Fixes

3.0.0 (2020-07-01)
------------------
- Fixes for Chef 15

2.3.1 (2020-02-25)
------------------
- Enable and start mond service

2.3.0 (2020-01-14)
------------------
- Chef 14 post-migration fixes

2.2.0 (2019-12-10)
------------------
- Migrate away from kernel-modules cookbook

2.1.0 (2019-09-12)
------------------
- Inspec tests

2.0.0 (2018-08-21)
------------------
- Chef 13 compatibility fixes

1.5.1 (2018-01-02)
------------------
- Properly set /root/.ssh to 0700

1.5.0 (2018-01-02)
------------------
- Properly enable systemd services

1.4.3 (2017-11-30)
------------------
- Work around issue with --enabled-disk-templates on older versions of Ganeti

1.4.2 (2017-07-20)
------------------
- Don't set default settings for instance-image

1.4.1 (2017-07-13)
------------------
- Don't manage ganeti-cron

1.4.0 (2017-07-13)
------------------
- instance_image_hook resource

1.3.1 (2017-07-13)
------------------
- Update lvm.conf and split by platform versions

1.3.0 (2017-07-13)
------------------
- Split out kvm code into its own recipe

1.2.1 (2017-07-13)
------------------
- Standardize kvm and ganeti attributes using case statements

1.2.0 (2017-07-13)
------------------
- Separate drbd into it's own recipe

1.1.1 (2017-07-12)
------------------
- Refactor yum/apt repository support

1.1.0 (2017-07-12)
------------------
- instance_image recipe imported from ganeti-instance-image

1.0.1 (2017-07-07)
------------------
- CentOS 7 support

1.0.0 (2017-07-05)
------------------
- Standards update and cleanup

# 0.1.0

Initial release of ganeti

* Enhancements
  * an enhancement

* Bug Fixes
  * a bug fix
