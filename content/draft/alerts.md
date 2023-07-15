---
title: "Alerts"
draft: true
---

Alerts are a useful feature that add side content such as tips, notes, or warnings to your articles. They are especially handy when writing educational tutorial-style articles. Use the corresponding shortcodes to enable alerts inside your content:

    {{%/* alert info */%}}
    Here's a tip or note...
    {{%/* /alert */%}}

This will display the following _note_ block:

{{< notice info >}}
Here's a tip or note...
{{< /notice >}}

---

All four styles below:

{{% alert success %}}
Here's a success...
{{< /notice >}}

{{< notice info >}}
Here's a info...
{{< /notice >}}

{{< notice warning >}}
Here's a warning...
{{< /notice >}}

{{< notice warning >}}
Here's a danger...
{{< /notice >}}
