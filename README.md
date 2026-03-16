# Terraform Task 9 – State Migration to Scale Instances Using `count`

## 📌 Objective

This task demonstrates how to **scale an existing Terraform-managed resource from a single instance to multiple instances using the `count` meta-argument without destroying the existing resource**.

Normally, adding `count` to an existing resource causes Terraform to **recreate the resource**, which can lead to downtime.

To prevent this, we **migrate the Terraform state** so that the existing instance becomes **index `[0]`**.

---

# 🧠 Scenario

Initial infrastructure:

```
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"
}
```

Terraform manages **one EC2 instance**.

New requirement:

- Scale to **5 instances**
- Preserve the **existing instance**
- Avoid destruction or recreation

---

# 📂 Project Structure

```
terraform-state-migration/
│
├── main.tf
├── terraform.tfstate
└── README.md
```

---

# ⚙️ Step 1 – Existing Terraform Configuration

Initial configuration without `count`:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-instance"
  }
}
```

Initialize Terraform:

```bash
terraform init
```

Apply the configuration:

```bash
terraform apply
```

This creates **one EC2 instance**.

---

# 🔄 Step 2 – Modify Terraform Configuration

Update the resource to use **count = 5**.

```hcl
resource "aws_instance" "web" {
  count = 5

  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-instance-${count.index}"
  }
}
```

At this point, running `terraform plan` will show that the existing instance will be **destroyed and recreated**, which we want to avoid.

---

# 🧩 Step 3 – Perform Terraform State Migration

First check the current state:

```bash
terraform state list
```

Output:

```
aws_instance.web
```

Move the state to index `[0]`:

```bash
terraform state mv aws_instance.web aws_instance.web[0]
```

This command tells Terraform:

```
Existing instance = index 0
```

---

# 🔍 Step 4 – Verify the State

Run:

```bash
terraform state list
```

Output:

```
aws_instance.web[0]
```

Now Terraform recognizes the existing instance as the **first instance in the count list**.

---

# 🚀 Step 5 – Apply Terraform Configuration

Run:

```bash
terraform plan
```

Expected result:

```
Plan: 4 to add, 0 to change, 0 to destroy
```

Terraform will create:

```
aws_instance.web[1]
aws_instance.web[2]
aws_instance.web[3]
aws_instance.web[4]
```

The **existing instance remains unchanged**.

Apply the changes:

```bash
terraform apply
```

---

# 🎯 Result

Infrastructure now contains:

```
aws_instance.web[0]  → existing instance
aws_instance.web[1]
aws_instance.web[2]
aws_instance.web[3]
aws_instance.web[4]
```

Total instances: **5**

No existing resource was destroyed.

---

# 🛠 Useful Terraform State Commands

### List resources in state

```bash
terraform state list
```

### Show resource details

```bash
terraform state show aws_instance.web[0]
```

### Move resource in state

```bash
terraform state mv SOURCE DESTINATION
```

Example:

```bash
terraform state mv aws_instance.web aws_instance.web[0]
```

---

# ⚠️ Best Practices

- Always **backup the Terraform state file** before migration
- Use **terraform plan** before applying changes
- Perform state operations carefully
- Prefer **remote state (S3 + DynamoDB locking)** in production

---

# 🎓 Learning Outcomes

After completing this task you will understand:

- Terraform state management
- State migration techniques
- Using `count` for scaling infrastructure
- Preventing resource recreation
- Infrastructure scaling without downtime

---

# 👨‍💻 Author

**Naveen Asarala**  
DevOps Engineer | AWS | Terraform | Kubernetes  


---

⭐ If this project helped you, consider **starring the repository**.
