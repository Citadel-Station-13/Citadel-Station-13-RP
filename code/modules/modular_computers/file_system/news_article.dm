/**
 * /data/ files store data in string format.
 * They don't contain other logic for now.
 */
/datum/computer_file/data/news_article
	filetype = "XNML"
	filename = "Unknown News Entry"
	/// Results in smaller files.
	block_size = 5000
	/// Editing the file breaks most formatting due to some HTML tags not being accepted as input from average user.
	do_not_edit = 1
	/// File path to HTML file that will be loaded on server start. Example: '/news_articles/space_magazine_1.html'. Use the /news_articles/ folder!
	var/server_file_path
	/// Set to 1 for older stuff.
	var/archived
	/// Filename of cover.
	var/cover

/datum/computer_file/data/news_article/New(var/load_FROM_FILE = 0)
	..()
	if(server_file_path && load_FROM_FILE)
		stored_data = file2text(server_file_path)
	calculate_size()


//! ## NEWS DEFINITIONS BELOW THIS LINE
/* KEPT HERE AS AN EXAMPLE
/datum/computer_file/data/news_article/space/vol_one
	filename = "SPACE Magazine vol. 1"
	server_file_path = 'news_articles/space_magazine_1.html'
*/
