setup:
	git clone https://github.com/yonaskolb/Mint.git
	cd Mint && make
	rm -rf Mint
	mint bootstrap
	make build-library
	touch Configs/debug.xcconfig
	touch Configs/release.xcconfig

mint-self-update:
	mint install yonaskolb/mint

build:
	mint run xcodegen generate
	open StructurePlayground.xcodeproj

build-library:
	carthage bootstrap --platform iOS --cache-builds

update-library:
	carthage update --platform iOS