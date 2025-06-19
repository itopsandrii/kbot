# Creating a Pre-commit Hook

## Step 1: Open Terminal
Open the terminal (command prompt) at the root of your Git repository.

Navigate to the hidden `.git/hooks` directory. This is where Git "hooks" live.

```bash
cd .git/hooks
```

## Step 2: Create the `pre-commit` File

Create a file named `pre-commit` (without extension). On Linux/macOS you can use:

```bash
touch pre-commit
```

On Windows, you can create the file using Notepad, but make sure it has no `.txt` extension.

Open this file in a text editor and paste the following script (we use bash since it works almost everywhere):

```bash
#!/bin/sh

# Display a message that the check is starting
echo "Running gitleaks scan..."

# Run gitleaks on staged files
gitleaks protect --staged -v

# Save the exit code of the previous command
RESULT=$?

# Check if a secret was found
if [ $RESULT -ne 0 ]; then
  echo "----------------------------------------"
  echo "ERROR: Gitleaks found secrets in your code."
  echo "Commit has been rejected. Please remove secrets and try again."
  echo "----------------------------------------"
  exit 1 # Reject the commit
fi

# Exit with 0 to allow the commit
exit 0
```

## Step 3: Make the Script Executable

On macOS and Linux, Git requires the hook file to be executable. Run the following command inside the `.git/hooks` directory:

```bash
chmod +x pre-commit
```

On Windows, this step is not required.

## Step 4: Test the Hook

Return to the project root:

```bash
cd ../..
```

Create a file called `bot.py` with a fake Telegram token:

```python
# bot.py
TELEGRAM_BOT_TOKEN = "TOKEN"
```

Try committing the file:

```bash
git add bot.py
git commit -m "Add telegram bot"
```

### Expected Output

You should see a message from gitleaks indicating a secret was found, followed by our error message. The commit will be rejected.

```
Running gitleaks scan...
... (gitleaks output) ...
----------------------------------------
ERROR: Gitleaks found secrets in your code.
Commit has been rejected. Please remove secrets and try again.
----------------------------------------
```

Now remove or comment out the line with the token in `bot.py`, stage the file again, and try committing. This time, it should succeed.