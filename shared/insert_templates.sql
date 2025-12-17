INSERT INTO public.lables (name)
VALUES ('Your Label Name');

INSERT INTO public.people (name, alias, korean_name, born, deceased, retired)
VALUES ('Your Full Name', 'Your Alias', 'Your Korean Name', 'YYYY-MM-DD', NULL, FALSE);

-- BAND_GENDER options: 'boys', 'girls', 'mixed'
INSERT INTO public.bands (name, korean_name, formed, origin, gender, website)
VALUES ('Your Band Name', 'Your Korean Name', 'YYYY-MM-DD', 'Your Origin City/Country', 'boys', 'http://yourwebsite.com');

-- MEMBER_ROLE options: 'leader', 'vocalist', 'dancer', 'rapper', 'maknae', 'visual', 'center'
-- Note: band_id and person_id should refer to existing records in bands and people tables respectively.
INSERT INTO public.band_members (band_id, person_id, joined, "left", role)
VALUES (1, 1, 'YYYY-MM-DD', NULL, 'vocalist');

INSERT INTO public.tracks (title, duration, lyrics, released, mp3)
VALUES ('Your Track Title', '00:03:30', 'Your lyrics here...', 'YYYY-MM-DD', NULL);

-- Note: You must provide either person_id OR band_id, but not both.
-- For a person as author:
INSERT INTO public.track_authors (track_id, person_id, band_id)
VALUES (1, 1, NULL);
-- For a band as author:
INSERT INTO public.track_authors (track_id, person_id, band_id)
VALUES (1, NULL, 1);

-- ALBUM_TYPE options: 'Studio', 'EP', 'Soundtrack', 'Live', 'Compilation', 'Reissue', 'Single'
-- Note: label_id should refer to an existing record in the lables table.
INSERT INTO public.albums (title, released, label_id, type, duration)
VALUES ('Your Album Title', 'YYYY-MM-DD', 1, 'Studio', '00:45:00');

-- Note: album_id and track_id should refer to existing records in albums and tracks tables respectively.
INSERT INTO public.album_tracks (album_id, track_id, track_number)
VALUES (1, 1, 1);
