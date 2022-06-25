import gg
import gx
import rand

struct App {
mut:
	gg &gg.Context = 0
}

const (
	title = "DVD Bouncer"
	window_width = 960
	window_height = 640
	size_x = 160.0
	size_y = 66.0
	speed = f32(4.0)
)

__global (
	px = f32(window_width/2 - size_x/2)
	py = f32(window_height/2 - size_y/2)
	dx = 1
	dy = 1
	dvd_color = gx.Color{255, 255, 255, 255}
	dvd_image = gg.Image{}
)

fn main() {
	mut app := &App{}
	app.gg = gg.new_context(
		bg_color: gx.black
		width: window_width
		height: window_height
		window_title: title
		frame_fn: frame
		event_fn: on_event
	)
	dvd_image = app.gg.create_image('./logo.png')

	app.gg.run()
}

fn gen_color() {
	dvd_color.r = u8(rand.int_in_range(0, 255) or { panic('err') })
	dvd_color.g = u8(rand.int_in_range(0, 255) or { panic('err') })
	dvd_color.b = u8(rand.int_in_range(0, 255) or { panic('err') })
}

fn on_event(mut e &gg.Event, mut app App) {
	match e.typ {
		.key_down {
			if e.key_code == gg.KeyCode.escape {
				exit(0)
			}
		}
		else {}
	}
}

fn frame(mut ctx gg.Context) {
	if px <= 0 || px >= window_width - size_x {
		dx *= -1
		gen_color()
	}
	if py <= 0 || py >= window_height - size_y {
		dy *= -1
		gen_color()
	}
	px += speed*dx
	py += speed*dy

	ctx.begin()
	ctx.draw_image_with_config(
		img: &dvd_image
		img_rect: gg.Rect{px, py, dvd_image.width/2, dvd_image.height/2}
		color: dvd_color
	)
	ctx.end()
}

