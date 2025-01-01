import os
import re
import shutil

# Paths
posts_dir = "/Users/alegarciy/Documents/Github-personal/halegarciy/content/Posts/"
attachments_dir = "/Users/alegarciy/Documents/Github-personal/Zettelkasten/Attachments/"
static_images_dir = "/Users/alegarciy/Documents/Github-personal/halegarciy/static/images/"

# Ensure the static images directory exists
# os.makedirs(static_images_dir, exist_ok=True)


# Step 1: Process each markdown file in the posts directory
for filename in os.listdir(posts_dir):
    if filename.endswith(".md"):
        filepath = os.path.join(posts_dir, filename)

        with open(filepath, "r") as file:
            content = file.read()

        # Step 2: Find all image links in the format ![Image Description](filename.png)
        images = re.findall(r'\[\[([^]]*\.(?:jpg|jpeg|png|gif|bmp|tiff|webp|svg))\]\]', content)

        # Step 3: Process each image
        for image in images:
            # Extract the filename (if path contains directories, just get the basename)
            image_filename = os.path.basename(image)
            image_source = os.path.join(attachments_dir, image_filename)

            # Ensure the image exists in the attachments directory
            if os.path.isfile(image_source):
                # Copy the image to the static/images directory
                shutil.copy(image_source, static_images_dir)

                # Replace the image link in the Markdown file
                markdown_image = f"![Image Description](/images/{image.replace(' ', '%20')})"
                content = content.replace(f"![[{image}]]", markdown_image)
            else:
                print(f"Warning: Image {image_source} not found.")

        # Step 5: Write the updated content back to the markdown file
        with open(filepath, "w") as file:
            file.write(content)

print("Markdown files processed and images copied successfully.")
