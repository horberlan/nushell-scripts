def show_image [folder_path: string, images: list<string>, current: int] {
    kitty +kitten icat $"($images | get $current)" 
    if $current == 0 {
        print $"(ansi green)This is the first image in the directory.(ansi green)"
    } else if $current == ($images | length) - 1 {
        print $"(ansi red)This is the last image in the directory.(ansi red)"
    }
}

def rotate_image [folder_path: string, images: list<string>, current: int, angle: int] {
    let image_path = $"($images | get $current)"
    run-external "convert" $image_path "-rotate" $angle $image_path
}

def main [args] {
    if ($args | length) == 1 {
        print $args
        let folder_path = (
        if ($args | path type ) == "dir" {
            $args
        } else {
            $args | path dirname
        }
    )
        let images = ls -m $folder_path | where type =~ "image" | get name         
        # print $folder_path
        # print $images
        let total = ($images | length)
        mut current = 0
        
        loop {
            show_image $folder_path $images $current

            print [["next", "previous", "rotate up", "rotate down"]; [ "",  "", "", ""]]

            let key = (input listen --types [key])
            match $key.code {
                "up" => { rotate_image $folder_path $images $current 90 }
                "down" => { rotate_image $folder_path $images $current -90 }
                "right" => { if $current < $total - 1 { $current = $current + 1 } }
                "left" => { if $current > 0 { $current = $current - 1 } }
                "q" => { break }
                _ => { print  "The key is definitely not mapped."}
            }
        }
    } else {
        print $"Usage: ($nu.env.CURRENT_FILE) <folder_path>"
        exit 1
    }
}
