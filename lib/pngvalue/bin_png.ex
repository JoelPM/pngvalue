defmodule PNGValue.BinPNG do
  require Record

  Record.defrecord :png_config, Record.extract(:png_config, from_lib: "png/include/png.hrl")

  def create(bin) do
    sz = byte_size(bin)
    bit_depth = 8
    {width, height} = dims(sz)
    config = png_config( size: {width, height}, mode: {:grayscale, bit_depth} )
    rows = make_rows(bin, width, bit_depth)

    hdr = :png.header()
    cfg = :png.chunk(:IHDR, config)
    [dat] = :png.chunk(:IDAT, {:rows, rows})
    eof = :png.chunk(:IEND)

    hdr <> cfg <> dat <> eof
  end

  defp dims(sz) do
    w = sz |> :math.sqrt |> round
    h = sz |> div(w)
    case rem sz, w do
      0 -> {w, h}
      _ -> {w, h+1}
    end
  end

  defp make_rows(bin, width, bit_depth, rows \\ []) do
    case byte_size(bin) do
      x when x > width ->
        <<row :: binary-size(width), rest :: binary>> = bin
        make_rows(rest, width, bit_depth, [row|rows])
      x when x < width ->
        pad = String.duplicate(<<0>>, width - x)
        row = bin <> pad
        Enum.reverse([row|rows])
      _ ->
        Enum.reverse([bin|rows])
    end
  end
end

