all: image

clean:
	rm -f *.img
	rm -f *.deb

raspios_lite.img:
	wget https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2024-11-19/2024-11-19-raspios-bookworm-arm64-lite.img.xz
	unxz -f 2024-11-19-raspios-bookworm-arm64-lite.img.xz
	mv 2024-11-19-raspios-bookworm-arm64-lite.img raspios_lite.img
	sudo sdm --customize raspios_lite.img --extend --xmb 4096

telegraf.deb:
	wget https://dl.influxdata.com/telegraf/releases/telegraf_1.33.1-1_arm64.deb
	mv telegraf_1.33.1-1_arm64.deb telegraf.deb

image: raspios_lite.img telegraf.deb
	sudo sdm --customize raspios_lite.img --plugin @plugins --redo-customize --ecolors silver:gray:green

HOSTNAME ?= smpbr

burn:
	sudo sdm --burn /dev/$(DEVICE) --hostname $(HOSTNAME) --expand-root raspios_lite.img

explore:
	sudo sdm --explore --ecolors silver:gray:green raspios_lite.img

mass_burn:
	sudo /usr/local/sdm/sdm-gburn raspios_lite.img flash_file.data /dev/$(DEVICE)

