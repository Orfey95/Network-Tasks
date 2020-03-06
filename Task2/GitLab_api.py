"""GitLab API
This script allows the user interact with GitLab API.
List Function:
Create project - create new GitLab project in specific group
Add/delete/change project member - addition or deletion or changing GitLab project member
Add/delete project tag - addition or deletion GitLab project tag
Create issue - create new GitLab issue
"""

import sys
import requests
import re
import json


__ERROR_ARGUMENT = 2  # problem with arguments


def get_user_id_by_name(user_name, private_token):
    """Get user id by name
    :param user_name: str
        User name
    :param private_token: str
        Access token
    :return: str
        Return user_id
    """
    response = requests.get(f'https://gitlab.com/api/v4/users/?username={user_name}&private_token={private_token}')
    user_id_list = re.findall(r'"id":(.*?),', str(response.content))
    if len(user_id_list) != 0:
        return user_id_list[0]
    else:
        return -1


def get_project_id_by_name(project_name, user_id, private_token):
    """Get project id by name
    :param project_name: str
        Name of project
    :param user_id: str
        User id
    :param private_token: str
        Access token
    :return: str
        Return project_id
    """
    response = requests.get(f'https://gitlab.com/api/v4/users/{user_id}/projects?private_token={private_token}')
    project_name_list = re.findall(r'"name":"(.*?)",', str(response.content))
    project_id_list = re.findall(r'"id":(.*?),', str(response.content))
    try:
        temp = project_name_list.index(project_name)
        return project_id_list[temp]
    except:
        return -1


def get_group_id_by_name(group_name, private_token):
    """Get group id by name
    :param group_name: str
        Name of group
    :param private_token: str
        Access token
    :return: str
        Return group_id
    """
    response = requests.get(f'https://gitlab.com/api/v4/groups?statistics=true&private_token={private_token}')
    group_name_list = re.findall(r'"name":"(.*?)",', str(response.content))
    group_id_list = re.findall(r'"id":(.*?),', str(response.content))
    try:
        temp = group_name_list.index(group_name)
        return group_id_list[temp]
    except:
        return -1


def get_milestone_id_by_name(milestone_name, user_name, project_name, private_token):
    """Get milestone id by name
    :param milestone_name: str
        Name of milestone
    :param user_name: str
        User name
    :param project_name: str
        Name of project
    :param private_token: str
        Access token
    :return: str
        Return milestone_id
    """
    user_id = get_user_id_by_name(user_name, private_token)
    project_id = get_project_id_by_name(project_name, user_id, private_token)
    response = requests.get(f'https://gitlab.com/api/v4/projects/{project_id}/milestones?title={milestone_name}&private_token={private_token}')
    milestone_id_list = re.findall(r'"id":(.*?),', str(response.content))
    if len(milestone_id_list) != 0:
        return milestone_id_list[0]
    else:
        return -1


def create_milestone(project_name, user_name, milestone_name, private_token):
    """Milestone creation
    :param project_name: str
        Name of project
    :param user_name: str
        User name
    :param milestone_name: str
        Name of milestone
    :param private_token: str
        Access token
    :return: str
        milestone_id
    """
    user_id = get_user_id_by_name(user_name, private_token)
    project_id = get_project_id_by_name(project_name, user_id, private_token)
    if user_id and project_id != -1:
        response = requests.post(f'https://gitlab.com/api/v4/projects/{project_id}/milestones?'
                                 f'title={milestone_name}&'
                                 f'private_token={private_token}')
        milestone_id = get_milestone_id_by_name(milestone_name, user_name, project_name, private_token)
        return milestone_id
    else:
        print('No user or project with this name exists.')
        sys.exit(__ERROR_ARGUMENT)


def create_project(name, group_name, private_token):
    """Project creation
    :param name: str
        Name of project
    :param group_name: str
        Name of group
    :param private_token: str
        Access token
    :return: str
        Return status code
    """
    namespace_id = get_group_id_by_name(group_name, private_token)
    if namespace_id != -1:
        response = requests.post(f'https://gitlab.com/api/v4/projects?'
                                 f'name={name}'
                                 f'&namespace_id={namespace_id}'
                                 f'&private_token={private_token}')
        return response
    else:
        print('No group with this name exists.')
        sys.exit(__ERROR_ARGUMENT)


def change_member(act, project_name, user_name, member_name, access_level, private_token):
    """Add or delete or change member of project
    :param act: str
        Action selection
    :param project_name: str
        Name of project
    :param user_name: str
        User name
    :param member_name: str
        Name of member
    :param access_level: int
        Access level
    :param private_token: str
        Access token
    :return: str
        Return status code
    """
    member_id = get_user_id_by_name(member_name, private_token)
    user_id = get_user_id_by_name(user_name, private_token)
    project_id = get_project_id_by_name(project_name, user_id, private_token)
    if user_id and project_id != -1:
        if act == 'add':
            response = requests.post(f'https://gitlab.com/api/v4/projects/{project_id}/members?'
                                     f'user_id={member_id}&'
                                     f'access_level={access_level}&'
                                     f'private_token={private_token}')
            return response
        if act == 'del':
            response = requests.delete(f'https://gitlab.com/api/v4/projects/{project_id}/members/{member_id}?'
                                       f'private_token={private_token}')
            return response
        if act == 'change':
            response = requests.put(f'https://gitlab.com/api/v4/projects/{project_id}/members/{member_id}?'
                                    f'access_level={access_level}&'
                                    f'private_token={private_token}')
            return response
    else:
        print('No user or project with this name exists.')
        sys.exit(__ERROR_ARGUMENT)


def change_tag(act, project_name, user_name, tag_name, ref, private_token):
    """Add or delete tag
    :param act: str
        Action selection
    :param project_name: str
        Name of project
    :param user_name: str
        User name
    :param tag_name: sr
        Name of tag
    :param ref: str
        refer of tag
    :param private_token: str
        Access token
    :return: str
        Return status code
    """
    user_id = get_user_id_by_name(user_name, private_token)
    project_id = get_project_id_by_name(project_name, user_id, private_token)
    if user_id and project_id != -1:
        if act == 'add':
            response = requests.post(f'https://gitlab.com/api/v4/projects/{project_id}/repository/tags?'
                                     f'tag_name={tag_name}&'
                                     f'ref={ref}&'
                                     f'private_token={private_token}')
            return response
        if act == 'del':
            response = requests.delete(f'https://gitlab.com/api/v4/projects/{project_id}/repository/tags/{tag_name}?'
                                       f'private_token={private_token}')
            return response
    else:
        print('No user or project with this name exists.')
        sys.exit(__ERROR_ARGUMENT)


def create_issue(project_name, user_name, title, due_date, labels, milestone_name, private_token):
    """Issue creation
    :param project_name: str
        Name of project
    :param user_name: str
        User name
    :param title: str
        Issue title
    :param due_date: str
        Issue due date
    :param labels: str
        Issue label
    :param milestone_name: str
        Issue milestone
    :param private_token: str
        Access token
    :return: str
        Return status code
    """
    user_id = get_user_id_by_name(user_name, private_token)
    project_id = get_project_id_by_name(project_name, user_id, private_token)
    if user_id and project_id != -1:
        milestone_id = get_milestone_id_by_name(milestone_name, user_name, project_name, private_token)
        if milestone_id == -1:
            milestone_id = create_milestone(project_name, user_name, milestone_name, private_token)
        response = requests.post(f'https://gitlab.com/api/v4/projects/{project_id}/issues?'
                                 f'title={title}&'
                                 f'due_date={due_date}&'
                                 f'labels={labels}&'
                                 f'milestone_id={milestone_id}&'
                                 f'private_token={private_token}')
        return response
    else:
        print('No user or project with this name exists.')
        sys.exit(__ERROR_ARGUMENT)
        
        
# print(create_project('new_147', 'jhjh', '2hQuku5zYXvrgniuFMHL'))
# print(change_member('add', 'new_pasdgja', 'oleksandr_frolov', 'jkbroker', 30, '2hQuku5zYXvrgniuFMHL'))
# print(change_tag('add', 'new_pasdgja', 'oleksandr_frolov', 'new_tag', 'master', '2hQuku5zYXvrgniuFMHL'))
# print(create_issue('new_pasdgja', 'oleksandr_frolov', 'try', '2020-03-11', 'new_label, new_label2', 'n_m2', '2hQuku5zYXvrgniuFMHL'))
