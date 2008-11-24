CREATE TABLE `colours` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `hex` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `countries` (
  `id` int(11) NOT NULL auto_increment,
  `region_id` int(11) default NULL,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `armies` int(11) default '0',
  `game_player_id` int(11) default NULL,
  `x_position` int(11) default NULL,
  `y_position` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `game_player_countries` (
  `id` int(11) NOT NULL auto_increment,
  `game_player_id` int(11) default NULL,
  `country_id` int(11) default NULL,
  `armies` int(11) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `game_players` (
  `id` int(11) NOT NULL auto_increment,
  `game_id` int(11) default NULL,
  `player_id` int(11) default NULL,
  `armies_to_allocate` int(11) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `completed_initial_allocation` int(11) default '0',
  `colour_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `games` (
  `id` int(11) NOT NULL auto_increment,
  `current_player` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `world_id` int(11) default NULL,
  `is_allocation_round` int(11) default '1',
  `player_list` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `neighbours` (
  `id` int(11) NOT NULL auto_increment,
  `country_id` int(11) default NULL,
  `neighbour_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `players` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `regions` (
  `id` int(11) NOT NULL auto_increment,
  `world_id` int(11) default NULL,
  `name` varchar(255) default NULL,
  `bonus` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `shape_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `worlds` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('20081114085627');

INSERT INTO schema_migrations (version) VALUES ('20081114085757');

INSERT INTO schema_migrations (version) VALUES ('20081114085925');

INSERT INTO schema_migrations (version) VALUES ('20081114090030');

INSERT INTO schema_migrations (version) VALUES ('20081114235643');

INSERT INTO schema_migrations (version) VALUES ('20081115000944');

INSERT INTO schema_migrations (version) VALUES ('20081115001027');

INSERT INTO schema_migrations (version) VALUES ('20081115001313');

INSERT INTO schema_migrations (version) VALUES ('20081115003311');

INSERT INTO schema_migrations (version) VALUES ('20081115035616');

INSERT INTO schema_migrations (version) VALUES ('20081115042840');

INSERT INTO schema_migrations (version) VALUES ('20081115054217');

INSERT INTO schema_migrations (version) VALUES ('20081116091027');

INSERT INTO schema_migrations (version) VALUES ('20081116103701');

INSERT INTO schema_migrations (version) VALUES ('20081117124219');

INSERT INTO schema_migrations (version) VALUES ('20081118021141');

INSERT INTO schema_migrations (version) VALUES ('20081119013232');

INSERT INTO schema_migrations (version) VALUES ('20081121015919');

INSERT INTO schema_migrations (version) VALUES ('20081121020033');

INSERT INTO schema_migrations (version) VALUES ('20081121020331');

INSERT INTO schema_migrations (version) VALUES ('20081121020945');