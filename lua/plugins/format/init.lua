-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   init.lua                                           :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2025/06/24 15:32:06 by jeportie          #+#    #+#             --
--   Updated: 2025/06/24 20:04:14 by jeportie         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

return {
  require 'plugins.format.conform',
  require 'plugins.format.lint',
  require 'plugins.format.autopairs',
  require 'plugins.format.guess-indent',
}
