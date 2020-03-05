import requests
import re


def create_project(project_name, group, token):
    response = requests.post(f'https://gitlab.com/api/v4/projects?'
                             f'name={project_name}'
                             f'&namespace_id={group}'
                             f'&private_token={token}')
    return response


def change_member(act, project_id, user_id, access_level, token):
    if act == 'add':
        response = requests.post(f'https://gitlab.com/api/v4/projects/{project_id}/members?'
                                 f'user_id={user_id}&'
                                 f'access_level={access_level}&'
                                 f'private_token={token}')
        return response
    if act == 'del':
        response = requests.delete(f'https://gitlab.com/api/v4/projects/{project_id}/members/{user_id}?'
                                   f'private_token={token}')
        return response
    if act == 'change':
        response = requests.put(f'https://gitlab.com/api/v4/projects/{project_id}/members/{user_id}?'
                                f'access_level={access_level}&'
                                f'private_token={token}')
        return response


def change_tag(act, project_id, tag_name, ref, token):
    if act == 'add':
        response = requests.post(f'https://gitlab.com/api/v4/projects/{project_id}/repository/tags?'
                                 f'tag_name={tag_name}&'
                                 f'ref={ref}&'
                                 f'private_token={token}')
        return response
    if act == 'del':
        response = requests.delete(f'https://gitlab.com/api/v4/projects/{project_id}/repository/tags/{tag_name}?'
                                   f'private_token={token}')
        return response


def create_issue(project_id, title, due_date, labels, milestone_id, token):
    check_milestone_id = requests.get(f'https://gitlab.com/api/v4/projects/{project_id}/milestones/{milestone_id}?private_token={token}')
    if check_milestone_id.status_code != 404:
        response = requests.post(f'https://gitlab.com/api/v4/projects/{project_id}/issues?title={title}&due_date={due_date}&labels={labels}&milestone_id={milestone_id}&private_token={token}')
    else:
        response = 'No such id'
    # milestone_id = (re.findall(r'"milestone":(.*?),', str(response.content)))[0]
    # print(milestone_id)
    return response


print(create_project('new_147', 7337546, '2hQuku5zYXvrgniuFMHL'))
# print(change_member('change', 17306214, 3496872, 10, '2hQuku5zYXvrgniuFMHL'))
# print(change_tag('add', 17306214, 'new_tag', 'master', '2hQuku5zYXvrgniuFMHL'))
# print(create_issue(17306214, 'try', '2020-03-11', 'new_label, new_label2', 1181925, '2hQuku5zYXvrgniuFMHL'))
